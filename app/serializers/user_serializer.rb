class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :first_name, :last_name, :avatar, :facebook, :linkedin, :twitter, :biography, :position, :created_at, :updated_at

  def initialize(object, options = {})
    @object = object
    @options = options
    @root = options[:root]
    @meta = options[:meta]
    @meta_key = options[:meta_key]
    @scope = options[:scope]

    scope_name = options[:scope_name]

    if scope_name && !respond_to?(scope_name)
      self.class.class_eval do
        define_method scope_name, lambda { scope }
      end
    end

    if object.role == User::ROLES[:author]
      @author_metadata = author_metadata
    end
    
  end

  def filter(keys)
    if object.role != User::ROLES[:author]
      keys - [:facebook] - [:linkedin] - [:twitter] - [:biography] - [:position]
    else
      keys
    end
  end

  def role    
    if object.role == User::ROLES[:admin]
      'admin'
    elsif object.role == User::ROLES[:estudent]
      'estudent'
    elsif object.role == User::ROLES[:author]
      'author'
    elsif object.role == User::ROLES[:institution_admin]
      'institution_admin'
    end
  end  
  
  def facebook
    @author_metadata.facebook
  end

  def linkedin
    @author_metadata.linkedin
  end

  def twitter
    @author_metadata.twitter
  end

  def biography
    @author_metadata.biography
  end

  def position
    @author_metadata.position
  end

  def avatar
    asset = Asset.where('entity_id' => object.id, 'entity_type' => 'user', 'definition' => 'avatar').first
    
    if asset
      asset.path
    else
      nil
    end
  end

  private
    def author_metadata
      author_metadata = AuthorMetadatum.where(user_id: object.id).first
    end
end
