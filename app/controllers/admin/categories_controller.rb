class Admin::CategoriesController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  actions :index, :new, :create, :edit, :update
  defaults resource_class: Category, collection_name: 'categories', instance_name: 'category'

  def update
    update! { admin_categories_path }
  end

end
