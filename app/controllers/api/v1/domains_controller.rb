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
      domain =  Domain.find_by("id = ? OR slug = ?", params[:id], params[:id])

      if domain
        render json: domain, status: 200, root: false
      else
        render json: { errors: domain.errors }, status: 404
      end
    end

    def admin_create
      domain = Domain.new(domain_params)    
      
      if domain.save      
        if params[:title]
          slug_string = slugify(domain.title)
          domain = check_existing_slug(domain, 'domain', slug_string)
          domain.save
        end
        render json: domain, status: 201, root: false
      else
        render json: { errors: domain.errors }, status: 422
      end
    end

    def admin_update
      domain = Domain.find_by("id = ? OR slug = ?", params[:id], params[:id])

      if domain.update(domain_params)
        if params[:title]
          slug_string = slugify(domain.title)
          domain = check_existing_slug(domain, 'domain', slug_string)
          domain.save
        end
        render json: domain, status: 200, root: false
      else
        render json: { errors: domain.errors }, status: 422
      end
    end

    def admin_destroy
      domain = Domain.find_by("id = ? OR slug = ?", params[:id], params[:id])
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
      domain = Domain.find_by("id = ? OR slug = ?", params[:id], params[:id])
      category.domain_id = domain.id
          
      if category.save
        if params[:title]
          slug_string = slugify(category.title)
          category = check_existing_slug(category, 'category', slug_string)
          category.save
        end
        render json: category, status: 201, root: false
      else
        render json: { errors: category.errors }, status: 422
      end
    end

    def admin_list_categories
      domain = Domain.find_by("id = ? OR slug = ?", params[:id], params[:id])
    
      render json: domain.categories, status: 201, root: false
    end
end