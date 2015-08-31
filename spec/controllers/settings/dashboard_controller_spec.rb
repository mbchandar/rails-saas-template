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

# Tests for the settings dashboard
RSpec.describe Settings::DashboardController, type: :controller do
  describe 'GET #index' do
    let(:account) { FactoryGirl.create(:account) }

    context 'as anonymous user' do
      it 'redirects to login page' do
        get :index, path: account.to_param
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
        get :index, path: account.to_param
        expect(response).to be_forbidden
      end

      it 'renders the forbidden' do
        get :index, path: account.to_param
        expect(response).to render_template('errors/forbidden')
        expect(response).to render_template('layouts/errors')
      end
    end

    context 'as account admin user' do
      before(:each) do
        user = FactoryGirl.create(:user)
        FactoryGirl.create(:user_permission, account: account, user: user, account_admin: true)
        sign_in :user, user
      end

      it 'responds successfully with an HTTP 200 status code' do
        get :index, path: account.to_param
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'sets the sidebar_item to accounts' do
        get :index, path: account.to_param
        expect(assigns(:sidebar_item)).to eq :settings_dashboard
      end

      it 'renders the show template' do
        get :index, path: account.to_param
        expect(response).to render_template('index')
        expect(response).to render_template('layouts/application')
      end
    end

    context 'as super admin user' do
      before(:each) do
        admin = FactoryGirl.create(:admin)
        sign_in :user, admin
      end

      it 'responds successfully with an HTTP 200 status code' do
        get :index, path: account.to_param
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'sets the sidebar_item to accounts' do
        get :index, path: account.to_param
        expect(assigns(:sidebar_item)).to eq :settings_dashboard
      end

      it 'renders the show template' do
        get :index, path: account.to_param
        expect(response).to render_template('index')
        expect(response).to render_template('layouts/application')
      end
    end
  end
end
