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

# Tests for the invoice model
RSpec.describe Invoice, type: :model do
  it 'should have valid factory' do
    expect(FactoryGirl.build(:invoice)).to be_valid
  end

  describe '.account' do
    it 'links to the account' do
      account = FactoryGirl.create(:account)
      invoice = FactoryGirl.create(:invoice, account: account)
      expect(invoice).to be_valid
      expect(invoice.account).to eq account
    end
  end

  describe '.account_id' do
    it 'must be an integer' do
      account = FactoryGirl.build(:account, paused_plan_id: 5.3)
      expect(account).to be_valid
      expect(account.paused_plan_id).to eq 5
    end
  end

  describe '.download_url' do
    it 'must be 255 characters or less' do
      invoice = FactoryGirl.build(:invoice, download_url: Faker::Lorem.characters(256))
      expect(invoice).to_not be_valid
      expect(invoice.errors[:download_url]).to include 'is too long (maximum is 255 characters)'
    end

    it 'can be nil' do
      invoice = FactoryGirl.build(:invoice, download_url: nil)
      expect(invoice).to be_valid
    end
  end

  describe '.inv_number' do
    it 'must be an integer' do
      invoice = FactoryGirl.build(:invoice, inv_number: 5.3)
      expect(invoice).to be_valid
      expect(invoice.inv_number).to eq 5
    end

    it 'must be unique' do
      invoice1 = FactoryGirl.create(:invoice, inv_number: 5)
      expect(invoice1).to be_valid
      invoice2 = FactoryGirl.build(:invoice, inv_number: 5)
      expect(invoice2).to_not be_valid
      expect(invoice2.errors[:inv_number]).to include 'has already been taken'
    end

    it 'is automatically assigned if nil' do
      invoice = FactoryGirl.create(:invoice)
      expect(invoice).to be_valid
      expect(invoice.inv_number).to_not be_nil
    end

    it 'cannot be set to blank' do
      invoice = FactoryGirl.create(:invoice)
      expect(invoice).to be_valid
      invoice.inv_number = nil
      expect(invoice).to_not be_valid
      expect(invoice.errors[:inv_number]).to include 'can\'t be blank'
    end
  end

  describe '.invoiced_at' do
    it 'is required' do
      invoice = FactoryGirl.build(:invoice, invoiced_at: '')
      expect(invoice).to_not be_valid
      expect(invoice.errors[:invoiced_at]).to include 'can\'t be blank'
    end
  end

  describe '.paid_at' do
    it 'is not required' do
      invoice = FactoryGirl.build(:invoice, paid_at: nil)
      expect(invoice).to be_valid
    end
  end

  describe '.stripe_invoice_id' do
    it 'must be 100 characters or less' do
      invoice = FactoryGirl.build(:invoice, stripe_invoice_id: Faker::Lorem.characters(101))
      expect(invoice).to_not be_valid
      expect(invoice.errors[:stripe_invoice_id]).to include 'is too long (maximum is 100 characters)'
    end

    it 'is required' do
      invoice = FactoryGirl.build(:invoice, stripe_invoice_id: '')
      expect(invoice).to_not be_valid
      expect(invoice.errors[:stripe_invoice_id]).to include 'can\'t be blank'
    end
  end

  describe '.to_s' do
    it 'returns inv_number' do
      invoice = FactoryGirl.build(:invoice, inv_number: 123)
      expect(invoice.to_s).to eq '123'
    end
  end

  describe '.total_amount' do
    it 'can have two decimal places' do
      invoice = FactoryGirl.build(:invoice, total_amount: 1.23)
      expect(invoice).to be_valid
      expect(invoice.total_amount).to eq 1.23
    end

    it 'is required' do
      invoice = FactoryGirl.build(:invoice, total_amount: '')
      expect(invoice).to_not be_valid
      expect(invoice.errors[:total_amount]).to include 'can\'t be blank'
    end
  end
end
