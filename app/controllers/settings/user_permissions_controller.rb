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

# Provides user permissions administration in the settings section
class Settings::UserPermissionsController < Settings::ApplicationController
  add_breadcrumb 'Users', :settings_user_permissions_path

  before_action :find_user_permission, only: [:destroy, :edit, :show, :update]

  authorize_resource

  def index
    @user_permissions = current_account.user_permissions.includes(:user).page(params[:page])
  end

  def edit
    add_breadcrumb 'Edit', edit_settings_user_permission_path(@user_permission)
  end

  def show
  end

  def update
    p = user_permissions_params
    if @user_permission.update_attributes(p)
      AppEvent.success("Updated user permissions #{@user_permission.user}", current_account, current_user)
      # rubocop:disable Metrics/LineLength
      logger.info { "User permission for '#{@user_permission.user}' updated - #{admin_account_url(@user_permission.account)}" }
      # rubocop:enable Metrics/LineLength
      redirect_to settings_user_permission_path(@user_permission), notice: 'User permissions were successfully updated.'
    else
      add_breadcrumb 'Edit', edit_settings_user_permission_path(@user_permission)
      logger.debug { "User persmissions update failed #{@user_permission.inspect}" }
      render 'edit'
    end
  end

  def destroy
    if @user_permission.destroy
      AppEvent.info("Deleted user_permission #{@user_permission.user}", current_account, current_user)
      # rubocop:disable Metrics/LineLength
      logger.info { "User permission for '#{@user_permission.user}' destroyed - #{admin_account_url(@user_permission.account)}" }
      # rubocop:enable Metrics/LineLength
      redirect_to settings_user_permissions_path, notice: 'User was successfully removed.'
    else
      logger.debug { "User persmissions destroy failed #{@user_permission.inspect}" }
      redirect_to settings_user_permission_path(@user_permission), alert: 'User could not be removed.'
    end
  end

  private

  def find_user_permission
    if params[:user_permission_id]
      id = param[:user_permission_id]
    else
      id = params[:id]
    end
    @user_permission = current_account.user_permissions.includes(:user).where(rec_num: id).first!
    @user = @user_permission.user
    add_breadcrumb @user, settings_user_permission_path(@user_permission)
  end

  def user_permissions_params
    params.require(:user_permission).permit(:account_admin)
  end

  def set_sidebar_item
    @sidebar_item = :users
  end
end
