class Api::V1::DomainsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json  

  def add_category
    send("#{current_user.role_name}_add_category")
  end

  def list_categories
    send("#{current_user.role_name}_list_categories")    
  end  

  private
    def admin_index
      domains = Domain.all

      render json: domains, status: 200, root: false
    end

    def admin_show
      domain =  Domain.find(params[:id])

      if domain
        render json: domain, status: 200, root: false
      else
        render json: { errors: domain.errors }, status: 404
      end
    end

    def admin_create
      domain = Domain.new(domain_params)    
      
      if domain.save      
        render json: domain, status: 201, root: false
      else
        render json: { errors: domain.errors }, status: 422
      end
    end

    def admin_update
      domain = Domain.find(params[:id])

      if domain.update(domain_params)      
        render json: domain, status: 200, root: false
      else
        render json: { errors: domain.errors }, status: 422
      end
    end

    def admin_destroy
      domain = Domain.find(params[:id])
      domain.destroy

      head 204    
    end
    
    def domain_params
      params.permit(:title, :description)
    end

    def category_params
      params.permit(:title, :description, :domain_id)
    end

    def admin_add_category
      category = Category.new(category_params)
      category.domain_id = params[:id]
          
      if category.save
        render json: category, status: 201, root: false
      else
        render json: { errors: category.errors }, status: 422
      end
    end

    def admin_list_categories
      domain = Domain.find(params[:id])
    
      render json: domain.categories, status: 201, root: false
    end
end