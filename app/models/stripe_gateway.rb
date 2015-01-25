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

# Gateway class for Stripe so that it can be abstracted and handled via delayed
# jobs
class StripeGateway
  class << self
    def import_plans
      Stripe::Plan.all.each do |p|
        plan = Plan.where(stripe_id: p.id).first
        unless plan
          plan = Plan.new(stripe_id: p.id, public: false)
        end
        plan.name = p.name
        plan.statement_description = p.statement_description
        plan.currency = p.currency.upcase
        plan.interval_count = p.interval_count
        plan.interval = p.interval
        plan.amount = p.amount
        plan.trial_period_days = p.trial_period_days
        puts plan.save
        puts plan.to_json
        puts plan.errors.to_json
      end
    end

    def import_customers
      Stripe::Customer.all.each do |c|
        account = Account.where(stripe_customer_id: c.id).first
        unless account
          account = account.new(stripe_customer_id: c.id, active: false)
        end
        account.company_name = c.description
        account.email = c.email
        s = c.subscriptions.all(limit: 1)
        if s[0]
          account.address_country
          account.card_token
          account.card_brand
          account.card_last4
          account.card_exp
          account.plan_id = Plan.where(stripe_id: s.plan.id).first
          account.stripe_subscription_id
        end

        puts account.save
        puts account.to_json
        puts account.errors.to_json
      end
    end
  end
end
