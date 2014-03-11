class Admins::Cms::BaseController < ComfortableMexicanSofa.config.base_controller.to_s.constantize

  protect_from_forgery

  # Authentication module must have #authenticate method
  include ComfortableMexicanSofa.config.admins_auth.to_s.constantize

  before_action :authenticate,
                :load_admins_site,
                :set_locale,
                :load_fixtures,
                :except => :jump
  
  layout 'admin/cms'
  
  if ComfortableMexicanSofa.config.admins_cache_sweeper.present?
    cache_sweeper *ComfortableMexicanSofa.config.admins_cache_sweeper
  end
  
  def jump
    path = ComfortableMexicanSofa.config.admins_route_redirect
    return redirect_to(path) unless path.blank?
    load_admins_site
    redirect_to admins_cms_site_pages_path(@site) if @site
  end
  
protected
  
  def load_admins_site
    if @site = ::Cms::Site.find_by_id(params[:site_id] || session[:site_id]) || ::Cms::Site.first
      session[:site_id] = @site.id
    else
      I18n.locale = ComfortableMexicanSofa.config.admins_locale || I18n.default_locale
      flash[:error] = I18n.t('cms.base.site_not_found')
      return redirect_to(new_admins_cms_site_path)
    end
  end

  def set_locale
    I18n.locale = ComfortableMexicanSofa.config.admins_locale || (@site && @site.locale)
    true
  end

  def load_fixtures
    return unless ComfortableMexicanSofa.config.enable_fixtures
    if %w(admin/cms/layouts admin/cms/pages admin/cms/snippets).member?(params[:controller])
      ComfortableMexicanSofa::Fixture::Importer.new(@site.identifier).import!
      flash.now[:error] = I18n.t('cms.base.fixtures_enabled')
    end
  end
end
