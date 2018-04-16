class ProgramUserRole < ApplicationRecord
  belongs_to :program, counter_cache: :members_count
  belongs_to :user
  PROGRAM_ROLES = [
    SUPER_MASTER_ROLE    = 1,
    MASTER_ROLE          = 2,
    COORDINATOR_ROLE     = 3,
    DESIGNER_ROLE        = 4,
    TRAINEE_ROLE         = 5,
  ].freeze

  PROGRAM_ROLE_NAMES = 
    {
      MASTER_ROLE=>{:name=>'Admin',              
        :val=>MASTER_ROLE
      },
      COORDINATOR_ROLE=>{:name=>'Coordinator',    
        :val=>COORDINATOR_ROLE
      },
      DESIGNER_ROLE=>{:name=>'Designer',          
        :val=>DESIGNER_ROLE
      },
      TRAINEE_ROLE=>{:name=>'Trainee',            
        :val=>TRAINEE_ROLE
      },
    }.freeze

  accepts_nested_attributes_for :program
  accepts_nested_attributes_for :user

  validates :program, presence: true
  validates :user, presence: true
  validates :role, presence: true
  # validates :availability, presence: true
  # validates :contribute, presence: true
  
  validates_uniqueness_of :user_id, scope: :program_id, :message=>"You have already requested membership to this program", :on => :create

  def program_user_role_names
    return PROGRAM_ROLE_NAMES
  end 

  def is_master_or_greater?
    self.role < COORDINATOR_ROLE
  end

  def is_coordinator_or_greater?
    self.role < DESIGNER_ROLE
  end

  def is_designer_or_greater?
    self.role < TRAINEE_ROLE
  end

  def is_trainee_or_greater?
    self.role < 9999
  end

  def role_name
    if PROGRAM_ROLE_NAMES.has_key?(self.role)
      PROGRAM_ROLE_NAMES[self.role][:name]
    elsif self.is_master_or_greater?
      "Master"
    elsif self.is_trainee_or_greater?
      "Trainee"
    end
  end

end
