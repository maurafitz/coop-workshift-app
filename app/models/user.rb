class User < ActiveRecord::Base
    has_secure_password
    validates :email, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
    message: ": an email is incorrectly formatted" }
    validates :first_name, presence: true
    validates :last_name, presence: true
    before_create :check_attrs_exist
    before_create :format_name
    

    has_attached_file :avatar, styles: { profile: "150x150>", thumb: "100x100>" }, default_url: "https://socialbelly.com/assets/icons/blank_user-586bd979abac4d7c7007414f5e94fe71.png"
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
    
    belongs_to :unit
    has_many :shifts
    has_many :workshifts
    has_many :preferences
    has_many :avails
    
    PERMISSION = {
          :member => 0, :manager => 1, :ws_manager =>2
    }
    
    def self.import(file)
        spreadsheet = open_spreadsheet(file)
        header = spreadsheet.row(1)
        added = []
        errors = []
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          user = find_by(email: row["email"]) || new
          user.attributes = row.to_hash.slice(*row.to_hash.keys)
          user.password = User.random_pw
          if (not user.sent_confirmation) and user.save
            added += [user]
          else
            errors += [user.errors]
          end
        end
        if errors.blank?
          return added else return errors end
    end
    
    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
        when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
        else raise "Unknown file type: #{file.original_filename}"           
      end
    end
    
    def full_name
      self.first_name.capitalize + " " + self.last_name.capitalize
    end
    
    def self.send_confirmation(id)
      user = find(id)
      if user
        mg_client = Mailgun::Client.new Rails.application.secrets.api_key
        user.update_attributes!(:sent_confirmation => true)
        new_password = User.random_pw
        user.update_attribute(:password, new_password)
        message_params = {
                          :from    => Rails.application.secrets.username,
                          :to      => user.email,
                          :subject => 'Welcome to Coop Workshift',
                          :text    => 'Your temporary password is ' + new_password + ' be sure to change this when you sign in.'
                        }
        # mg_client.send_message(Rails.application.secrets.domain, message_params)
      else
      end
    end
    
    def self.random_pw
      x = ('0'..'z').to_a.shuffle.first(8).join
      return x
    end
    
    def self.weekly_hours_addition
      #Should be called once a week, adds hours for every user
      User.all.each do |usr|
        usr.hour_balance += usr.unit.policy.starting_hour_balance
        usr.save()
      end
    end
    
    def self.add_hours_from_blown(user_blown_hours)
      #user_blown_hours maps user_id => blown_hours * 2
      user_blown_hours.each do |user_id, hours_to_add|
        user = User.find(user_id)
        if user
          user.hour_balance += hours_to_add
          user.save()
        else 
          puts "\nCannot find user with id #{user_id} while adding blown hours"
        end 
      end 
    end
    
    def has_saved_availability?
      self.avails.length > 0
    end
    
    def is_ws_manager?
      permissions == PERMISSION[:ws_manager]
    end
    
    def is_manager?
      permissions == PERMISSION[:manager]
    end
    
    def manager_rights?
      permissions >= PERMISSION[:manager]
    end 
    
    def is_member?
      permissions == PERMISSION[:member]
    end 
    
    def self.getPermissionCode(role)
      return PERMISSION[role.to_sym]
    end
    
    def getPermission
      if is_member?
        return "Member"
      elsif is_manager?
        return "Manager"
      else
        return "Workshift-Manager"
      end
    end
    
    def self.get_rankings_for ws
      available_users = []
      all.each do |user|
        available_users << user if (user.unit == ws.get_unit) and (user.is_available? ws)
      end
      
      preferences = Preference.joins(metashift: :workshifts).where(workshifts: {id: ws.id})
                               
      rankings = {}
      available_users.each do |user|
        rankings[user] = preferences.where(user: user).first.get_rating
      end
      rankings.sort_by {|_, rank| rank}.reverse.to_h
    end
    
    def is_available?(workshift)
      start_time = convert_to_military workshift.start_time
      end_time = convert_to_military workshift.end_time
      day = Preference.day_mapping.key(workshift.day)
      workshift_avails = self.avails.where(day: day, hour: start_time..end_time).order(:hour)
      length = workshift.length
      # check if user is available for `length` consecutive hours
      avail = false
      count = 0
      workshift_avails.each do |a|
        if a.status != "Unavailable" and a.status != ""
          if count == length - 1
            return true
          elsif avail
            count += 1
          else
            avail = true
            count += 1
          end
        else
          avail = false
          count = 0
        end
      end
      return false
    end
    
    def convert_to_military time
      time = time.downcase
      matcher = /^(\d?\d):(\d\d)(a|p)m$/
      time = matcher =~ time
      hour, ampm, = $1.to_i, $3
      if ampm == 'p'
        return hour + 12
      else
        return hour
      end
    end
    
    private
    def check_attrs_exist
      if (self.compensated_hours.blank?)
        self.compensated_hours = 0
      end
      if (self.permissions.blank?)
        self.permissions = PERMISSION[:member]
      end
    end
    
    def format_name
      first = self.first_name.downcase
      self.first_name = first.split.map(&:capitalize).join(' ')
      last = self.last_name.downcase
      self.last_name = last.split.map(&:capitalize).join(' ')
    end
end
