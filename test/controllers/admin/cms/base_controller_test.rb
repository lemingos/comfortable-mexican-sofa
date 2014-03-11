require_relative '../../../test_helper'

class Admins::Cms::BaseControllerTest < ActionController::TestCase

  def test_get_jump
    get :jump
    assert_response :redirect
    assert_redirected_to admins_cms_site_pages_path(cms_sites(:default))
  end
  
  def test_get_jump_with_redirect_setting
    ComfortableMexicanSofa.config.admins_route_redirect = '/cms-admins/sites'
    get :jump
    assert_response :redirect
    assert_redirected_to '/cms-admins/sites'
  end

end