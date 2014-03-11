require_relative '../test_helper'

class AuthenticationIntegrationTest < ActionDispatch::IntegrationTest
  
  module TestLockPublicAuth
    def authenticate
      return redirect_to('/lockout')
    end
  end
  
  module TestUnlockPublicAuth
    def authenticate
      true
    end
  end
  
  def test_get_with_unauthorized_access
    assert_equal 'ComfortableMexicanSofa::HttpAuth', ComfortableMexicanSofa.config.admins_auth
    get '/admins/sites'
    assert_response :unauthorized
    get '/'
    assert_response :success
  end
  
  def test_get_with_authorized_access
    http_auth :get, '/admins/sites'
    assert_response :success
  end
  
  def test_get_with_changed_default_config
    assert_equal 'ComfortableMexicanSofa::HttpAuth', ComfortableMexicanSofa.config.admins_auth
    ComfortableMexicanSofa::HttpAuth.username = 'newuser'
    ComfortableMexicanSofa::HttpAuth.password = 'newpass'
    http_auth :get, '/admins/sites'
    assert_response :unauthorized
    http_auth :get, '/admins/sites', {}, 'newuser', 'newpass'
    assert_response :success
  end
  
  def test_get_public_with_custom_auth
    Cms::ContentController.send :include, TestLockPublicAuth
    get '/'
    assert_response :redirect
    assert_redirected_to '/lockout'
    # reset auth module
    Cms::ContentController.send :include, TestUnlockPublicAuth
  end
end