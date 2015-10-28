class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  serialization_scope :current_user
  # before_filter :set_headers 
  include Authenticable
    
  def index
    send("#{current_user.role_name}_index")
  end
  
  def show
    send("#{current_user.role_name}_show")
  end

  def create
    send("#{current_user.role_name}_create")
  end

  def update
    send("#{current_user.role_name}_update")
  end

  def destroy
    send("#{current_user.role_name}_destroy")
  end

  def add_asset(params)

    asset = Asset.where(:entity_id => params['entity_id'], :entity_type => params['entity_type'], :definition => params['definition']).first

    if asset && asset.entity_type != 'section' && asset.definition != 'content'
      asset['path'] = params['path']
      asset.save
    else      
      asset = Asset.new(params)
      asset.save
    end

    asset
  end

  def serialize_section(section)
    serializer = CustomSectionSerializer.new(section, scope: serialization_scope, root: false).as_json
  end

  def set_aws_credentials()
    credentials = {
      'AccessKeyId' => ENV["ADMIN_AWS_KEY_ID"],
      'SecretAccessKey' => ENV["ADMIN_AWS_ACCESS_KEY"],
      'Bucket' => ENV["AWS_BUCKET"],
      'SeedBucket' => ENV["AWS_SEED_BUCKET"]
    } 

    Aws.config[:region] = ENV["AWS_REGION"]
    Aws.config[:credentials] = Aws::Credentials.new(credentials['AccessKeyId'], credentials['SecretAccessKey'])
  end

  def build_output(user, token = true)
    # convert user to json to add the auth token field to it    
    output = ActiveSupport::JSON.decode(user.to_json)
    
    if token
      output["auth_token"] = user[:auth_token]
    end

    if output["role"] == User::ROLES[:admin]
      output["role"] = 'admin'
    end

    if output["role"] == User::ROLES[:estudent]
      output["role"] = 'estudent'
    end

    if output["role"] == User::ROLES[:author]
      output["role"] = 'author'

      if !token
        author_metadata = AuthorMetadatum.where(user_id: user.id).first

        output["facebook"] = author_metadata.facebook
        output["twitter"] = author_metadata.twitter
        output["linkedin"] = author_metadata.linkedin
        output["biography"] = author_metadata.biography
        output["position"] = author_metadata.position
      end
    end

    if output["role"] == User::ROLES[:institution_admin]
      output["role"] = 'institution_admin'
    end
    
    asset = Asset.where('entity_id' => user.id, 'entity_type' => 'user', 'definition' => 'avatar').first
    
    if asset
      output["avatar"] = asset.path
    else
      output["avatar"] = nil
    end    

    output.to_json    
  end
end