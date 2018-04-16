class GdriveController < ApplicationController
  layout 'program'

  require 'google/apis/drive_v2'
  require 'google/api_client/client_secrets'

  def sharegfile
    g_file_params = Hash.new
    g_file_params["program_id"] = params["program_id"]
    g_file_params["user_id"] = current_user.id
    g_file_params["title"] = params["title"]
    g_file_params["direct_link"] = params["direct_link"]
    g_file_params["icon_link"] = params["icon_link"]
    @program_file = GDriveFile.new(g_file_params)

    g_file_save = true #@program_file.save

    respond_to do |format|
      if g_file_save
        format.html { redirect_to @program_file_save, notice: 'Drive file was successfully shared.' }
        format.json { render :show, status: :created, location: @program_file_save }
        format.js   { render :layout => false }
      else
        format.html { render :new }
        format.json { render json: @program_file_save.errors, status: :unprocessable_entity }
        format.js   { render :layout => false, status: 500 }
      end
    end
  end

  def creategfile
    @program = Program.find(params["program_id"])
    drive = Google::Apis::DriveV2::DriveService.new
    drive.authorization = auth_svcacc_gdrive
    
    program_folder = Google::Apis::DriveV2::ParentReference.new
    program_folder.update!({:id=>@program.gdrive_folder_id})
    @drive_file = drive.insert_file({parents:[program_folder],mime_type:params["file_type"]}, convert: nil, ocr: nil, ocr_language: nil, pinned: nil, timed_text_language: nil, timed_text_track_name: nil, use_content_as_indexable_text: nil, visibility: nil, fields: nil, quota_user: nil, user_ip: nil, upload_source: nil, content_type: nil, options: nil)
    @drive_file = @drive_file.to_h

    GDriveFileWorker.perform_async(@drive_file[:id], @program.id, @program.name)

    g_file_params = Hash.new
    g_file_params["program_id"] = params["program_id"]
    g_file_params["user_id"] = current_user.id
    g_file_params["title"] = params["gfile_title"]
    g_file_params["direct_link"] = @drive_file[:alternate_link]
    g_file_params["icon_link"] = @drive_file[:icon_link]
    @program_file = GDriveFile.new(g_file_params)
    g_file_save = true #@program_file.save
  end  

  def listsharefiles
    if !session.has_key?(:credentials)
      if !params["program_id"].nil?
        session[:program_id] = params["program_id"]
      end
      redirect_to '/programs/gdrive/oauthdrivecallback'
    else
      client_opts = JSON.parse(session[:credentials])
      begin
        auth_client = Signet::OAuth2::Client.new(client_opts)
      rescue
        redirect_to '/programs/gdrive/oauthdrivecallback'
      end
      get_oauth_gfiles(params)
      if !params["program_id"].nil?
        session[:program_id] = params["program_id"]
      end
      @program_id = session["program_id"]
      @current_member_role = 9999
      if !request.xhr?
        get_svcacc_gfiles(params)
        @program = Program.find(@program_id)
        @members = ProgramUserRole.where(:program_id=>@program.id)
        @isMember = false
        if !current_user.nil? 
          @current_member_role = @members.where(:user_id=>current_user.id)
          if !@current_member_role.empty?
            @isMember = true
            @current_member_role = @current_member_role.first
          else
            @current_member_role = nil
          end
        end

        @programchat = Message.where(:program_id=>@program.id)
      end
      respond_to do |format|
        format.html
        format.json { render json: @sharefiles }
        format.js
      end
    end
  end

  def oauthdrivecallback
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      :scope => ['https://www.googleapis.com/auth/drive.metadata.readonly', 'https://www.googleapis.com/auth/drive.file'],
      :redirect_uri => request.original_url.split('?').first)
    if params['code'].nil?
      auth_uri = auth_client.authorization_uri.to_s
      redirect_to(auth_uri)
    else
      auth_client.code = params['code']
      auth_client.fetch_access_token!
      auth_client.client_secret = nil
      session[:credentials] = auth_client.to_json
      program_id = session[:program_id]
      redirect_to('/programs/'+program_id+'/gdrive/listsharefiles')
    end
  end

  def destroy
    @program_file = GDriveFile.find(params[:id])
    @program_file.destroy
    respond_to do |format|
      format.html { redirect_to programs_url, notice: 'File was successfully unshared.' }
      format.json { head :no_content }
    end
  end

  private
    def auth_svcacc_gdrive
      scope = ['https://www.googleapis.com/auth/drive']

      ENV["GOOGLE_APPLICATION_CREDENTIALS"] = Rails.root.join('spacedecentral-creds.json').to_s
      authorization = Google::Auth.get_application_default(scope)

      auth_client = authorization.dup
      auth_client.sub = 'gsuite@space.coop'
      auth_client.fetch_access_token!
      return auth_client
    end

    def get_svcacc_gfiles(params)
      sva_drive = Google::Apis::DriveV2::DriveService.new
      Google::Apis.logger.level = Logger::ERROR
      auth_client = auth_svcacc_gdrive
      sva_drive.authorization = auth_client
      sort_by = "modifiedDate "
      @programfiles = {:items=>[]}
      if !params['sort_by'].nil?
        sort_by = params['sort_by']
      end
      if params['sort_dir'] != "1"
        sort_by += " desc"
      end
      if !params["program_file_search_term"].nil?
        @program_file_search_term = params["program_file_search_term"]
        if @program_file_page.nil?
          @programfiles = sva_drive.list_files(q: "'#{@program.gdrive_folder_id}' in parents and title contains '#{@program_file_search_term}'", order_by: sort_by, fields: "items(modifiedDate,iconLink,alternateLink,title,id),next_page_token,self_link", options: { authorization: auth_client })
        else
          @programfiles = sva_drive.list_files(q: "'#{@program.gdrive_folder_id}' in parents and title contains '#{@program_file_search_term}'", max_results: 20, page_token: @program_file_page, order_by: sort_by, fields: "items(modifiedDate,iconLink,alternateLink,title,id),next_page_token,self_link", options: { authorization: auth_client })
        end
      else
        if @program_file_page.nil?
          @programfiles = sva_drive.list_files(q: "'#{@program.gdrive_folder_id}' in parents", order_by: sort_by, fields: "items(modifiedDate,iconLink,alternateLink,title,id),next_page_token,self_link", options: { authorization: auth_client })
        else
          @programfiles = sva_drive.list_files(q: "'#{@program.gdrive_folder_id}' in parents", max_results: 20, page_token: @program_file_page, order_by: sort_by, fields: "items(modifiedDate,iconLink,alternateLink,title,id),next_page_token,self_link", options: { authorization: auth_client })
        end
      end
      @programfiles = @programfiles.to_h
      @program_file_next_page = @programfiles[:next_page_token]
      @program_file_page = [:self_link]
      @params = params
    end

    def get_oauth_gfiles(params)
      drive = Google::Apis::DriveV2::DriveService.new
      Google::Apis.logger.level = Logger::ERROR
      # TODO bug client secret is missing 
      @share_search_page = params["page"]
      @share_search_prev_page = params["cur_page"]
      @sharefiles = Hash.new
      @share_search_term = ""
      sort_by = "modifiedDate "
      if !params['sort_by'].nil?
        sort_by = params['sort_by']
      end
      if params['sort_dir'] != "1"
        sort_by += " desc"
      end
      #http://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/DriveV2/DriveService#list_files-instance_method
      if !params["term"].nil?
        @share_search_term = params["term"]
        # @sharefiles = drive.fetch_all do | token |
        if @share_search_page.nil?
          @sharefiles = drive.list_files(q: "title contains '#{@share_search_term}'", max_results: 20, order_by: sort_by, fields: "items(iconLink,alternateLink,title,id),next_page_token,self_link", options: { authorization: auth_client })
        else
          @sharefiles = drive.list_files(q: "title contains '#{@share_search_term}'", max_results: 20, page_token: @share_search_page, order_by: sort_by, fields: "items(iconLink,alternateLink,title,id),next_page_token,self_link", options: { authorization: auth_client })
        end
        # end
      else
        # @sharefiles = drive.fetch_all do | token |
        if @share_search_page.nil?
          @sharefiles = drive.list_files(max_results: 20, order_by: sort_by, fields: "items(iconLink,alternateLink,title,id),next_page_token,self_link", options: { authorization: auth_client })
        else
          @sharefiles = drive.list_files(max_results: 20, page_token: @share_search_page, order_by: sort_by, fields: "items(iconLink,alternateLink,title,id),next_page_token,self_link", options: { authorization: auth_client })
        end
        # end
      end
      @sharefiles = @sharefiles.to_h
      # Rails.logger.info "<pre>#{JSON.pretty_generate(files.to_h)}</pre>"
      @share_search_next_page = @sharefiles[:next_page_token]
      @share_search_page = [:self_link]
    end

end
