# Encoding: utf-8

# Copyright (c) 2014-2015, Richard Buggy <rich@buggy.id.au>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'rails_helper'

# Tests for the settings accounts
RSpec.describe Settings::AccountsController, type: :controller do
  describe 'GET #edit' do
    before(:each) do
      @account = FactoryGirl.create(:account)
    end

    context 'as anonymous user' do
      it 'redirects to login page' do
        get :edit, path: @account.to_param
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'as unauthorized users' do
      before(:each) do
        user = FactoryGirl.create(:user)
        sign_in :user, user
      end

      it 'responds with forbidden' do
        get :edit, path: @account.to_param
        expect(response).to be_forbidden
      end

      it 'renders the forbidden' do
        get :edit, path: @account.to_param
        expect(response).to render_template('errors/forbidden')
        expect(response).to render_template('layouts/errors')
      end
    end

    context 'as account admin user' do
      before(:each) do
        user = FactoryGirl.create(:user)
        FactoryGirl.create(:user_permission, account: @account, user: user, account_admin: true)
        sign_in :user, user
      end

      it 'responds successfully with an HTTP 200 status code' do
        get :edit, path: @account.to_param
        expect(response).to be_success
        expect(response).to have_http_status(:success)
      end

      it 'sets the sidebar_item to accounts' do
        get :edit, path: @account.to_param
        expect(assigns(:sidebar_item)).to eq :settings_account
      end

      it 'renders the edit template' do
        get :edit, path: @account.to_param
        expect(response).to render_template('edit')
        expect(response).to render_template('layouts/application')
      end

      it 'assigns a edit account' do
        get :edit, path: @account.to_param
        a = assigns(:account)
        expect(a).to_not be_nil
        expect(a.id).to eq @account.id
      end
    end

    context 'as super admin user' do
      before(:each) do
        admin = FactoryGirl.create(:admin)
        sign_in :user, admin
      end

      it 'responds successfully with an HTTP 200 status code' do
        get :edit, path: @account.to_param
        expect(response).to be_success
        expect(response).to have_http_status(:success)
      end

      it 'sets the sidebar_item to accounts' do
        get :edit, path: @account.to_param
        expect(assigns(:sidebar_item)).to eq :settings_account
      end

      it 'renders the edit template' do
        get :edit, path: @account.to_param
        expect(response).to render_template('edit')
        expect(response).to render_template('layouts/application')
      end

      it 'assigns a edit account' do
        get :edit, path: @account.to_param
        a = assigns(:account)
        expect(a).to_not be_nil
        expect(a.id).to eq @account.id
      end
    end
  end

  describe 'GET #show' do
    before(:each) do
      @account = FactoryGirl.create(:account)
    end

    context 'as anonymous user' do
      it 'redirects to login page' do
        get :show, path: @account.to_param
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'as unauthorized users' do
      before(:each) do
        user = FactoryGirl.create(:user)
        sign_in :user, user
      end

      it 'responds with forbidden' do
        get :show, path: @account.to_param
        expect(response).to be_forbidden
      end

      it 'renders the forbidden' do
        get :show, path: @account.to_param
        expect(response).to render_template('errors/forbidden')
        expect(response).to render_template('layouts/errors')
      end
    end

    context 'as account admin user' do
      before(:each) do
        user = FactoryGirl.create(:user)
        FactoryGirl.create(:user_permission, account: @account, user: user, account_admin: true)
        sign_in :user, user
      end

      it 'responds successfully with an HTTP 200 status code' do
        get :show, path: @account.to_param
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'sets the sidebar_item to accounts' do
        get :show, path: @account.to_param
        expect(assigns(:sidebar_item)).to eq :settings_account
      end

      it 'renders the show template' do
        get :show, path: @account.to_param
        expect(response).to render_template('show')
        expect(response).to render_template('layouts/application')
      end

      it 'assigns a show account' do
        get :show, path: @account.to_param
        a = assigns(:account)
        expect(a).to_not be_nil
        expect(a.id).to eq @account.id
      end
    end

    context 'as super admin user' do
      before(:each) do
        admin = FactoryGirl.create(:admin)
        sign_in :user, admin
      end

      it 'responds successfully with an HTTP 200 status code' do
        get :show, path: @account.to_param
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'sets the sidebar_item to accounts' do
        get :show, path: @account.to_param
        expect(assigns(:sidebar_item)).to eq :settings_account
      end

      it 'renders the show template' do
        get :show, path: @account.to_param
        expect(response).to render_template('show')
        expect(response).to render_template('layouts/application')
      end

      it 'assigns a show account' do
        get :show, path: @account.to_param
        a = assigns(:account)
        expect(a).to_not be_nil
        expect(a.id).to eq @account.id
      end
    end
  end

  describe 'PATCH #update' do
    before(:each) do
      @account = FactoryGirl.create(:account)
    end

    context 'as anonymous user' do
      it 'redirects to login page' do
        patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'as unauthorized users' do
      before(:each) do
        user = FactoryGirl.create(:user)
        sign_in :user, user
      end

      it 'responds with forbidden' do
        patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
        expect(response).to be_forbidden
      end

      it 'renders the forbidden' do
        patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
        expect(response).to render_template('errors/forbidden')
        expect(response).to render_template('layouts/errors')
      end
    end

    context 'as account admin user' do
      before(:each) do
        user = FactoryGirl.create(:user)
        FactoryGirl.create(:user_permission, account: @account, user: user, account_admin: true)
        sign_in :user, user
      end

      context 'with valid attributes' do
        it 'sets the sidebar_item to accounts' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
          expect(assigns(:sidebar_item)).to eq :settings_account
        end

        it 'it redirects to account' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
          expect(response).to be_redirect
          expect(response).to redirect_to(settings_root_path)
        end

        it 'sets a notice' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
          expect(request.flash[:notice]).to eq 'Account was successfully updated.'
        end
      end

      context 'with invalid attributes' do
        it 'sets the sidebar_item to accounts' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
          expect(assigns(:sidebar_item)).to eq :settings_account
        end

        it 'it renders the edit template' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account, company_name: '')
          expect(response).to render_template('edit')
          expect(response).to render_template('layouts/application')
        end

        it 'it pass an existing account' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account, company_name: '')
          account = assigns(:account)
          expect(account).to_not be_nil
          expect(account).to_not be_new_record
        end
      end
    end

    context 'as super admin user' do
      before(:each) do
        admin = FactoryGirl.create(:admin)
        sign_in :user, admin
      end

      context 'with valid attributes' do
        it 'sets the sidebar_item to accounts' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
          expect(assigns(:sidebar_item)).to eq :settings_account
        end

        it 'it redirects to account' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
          expect(response).to be_redirect
          expect(response).to redirect_to(settings_root_path)
        end

        it 'sets a notice' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
          expect(request.flash[:notice]).to eq 'Account was successfully updated.'
        end
      end

      context 'with invalid attributes' do
        it 'sets the sidebar_item to accounts' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account)
          expect(assigns(:sidebar_item)).to eq :settings_account
        end

        it 'it renders the edit template' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account, company_name: '')
          expect(response).to render_template('edit')
          expect(response).to render_template('layouts/application')
        end

        it 'it pass an existing account' do
          patch :update, path: @account.to_param, account: FactoryGirl.attributes_for(:account, company_name: '')
          account = assigns(:account)
          expect(account).to_not be_nil
          expect(account).to_not be_new_record
        end
      end
    end
  end
end
