class Api::V1::DomainsController < ApplicationController
  before_action :authenticate_with_token!, except: [:show, :index]
  respond_to :json  
  ### ROUTE METHODS ###
  def add_category
    send("#{current_user.role_name}_add_category")
  end  

  def index
    domains = Domain.all

    render json: domains, status: 200, root: false
  end

  def show
    domain =  Domain.find(params[:id])

    if domain
      render json: domain, status: 200, root: false
    else
      render json: { errors: domain.errors }, status: 404
    end
  end

  def list_categories
    domain =  Domain.find(params[:id])
  
    render json: domain.categories, status: 201, root: false
  end

  private
    ### ADMIN METHODS ###
    def admin_create
      domain = Domain.new(domain_params)    
      
      domain.friendly_id
      domain.slug = nil
      title = params[:title].dup
      domain.clean_title = clean_title(title)

      if domain.save        
        render json: domain, status: 201, root: false
      else
        render json: { errors: domain.errors }, status: 422
      end
    end

    def admin_update
      domain =  Domain.find(params[:id])

      if params[:title]
        domain.friendly_id
        domain.slug = nil
        title = params[:title].dup
        domain.clean_title = clean_title(title)
      end

      if domain.update(domain_params)        
        render json: domain, status: 200, root: false
      else
        render json: { errors: domain.errors }, status: 422
      end
    end

    def admin_destroy
      domain =  Domain.find(params[:id])
      domain.destroy

      head 204    
    end

    def admin_add_category
      category = Category.new(category_params)
      domain =  Domain.find(params[:id])
      category.domain_id = domain.id
      
      category.friendly_id
      category.slug = nil
      title = params[:title].dup
      category.clean_title = clean_title(title)

      if category.save        
        render json: category, status: 201, root: false
      else
        render json: { errors: category.errors }, status: 422
      end
    end
    
    ### GENERAL METHODS ###
    def domain_params
      params.permit(:title, :description)
    end

    def category_params
      params.permit(:title, :description, :domain_id)
    end      
end