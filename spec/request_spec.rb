require 'spec_helper'
require 'cgi'
require 'digest/md5'

describe Paysera::Request do
  let(:valid_request) do
    {
        projectid:   56571,
        orderid:     1,
        accepturl:   '0.0.0.0:3000/get_request?accept',
        cancelurl:   '0.0.0.0:3000/get_request?cancel',
        callbackurl: '0.0.0.0:3000/get_request?callback',

    }
  end
  let(:sign_password) { '36947d6dcbccc03ad591deab138dbb0c' }

  subject { Paysera::Request.build_request(valid_request, sign_password) }

  describe '#build_request' do
    context 'when no projectid given' do
      let (:invalid_request) { valid_request.delete(:projectid); valid_request }
      it { expect { Paysera::Request.build_request(invalid_request, sign_password) }.to raise_error /projectid.+missing/ }
    end

    context 'when no orderid given' do
      let (:invalid_request) { valid_request.delete(:orderid); valid_request }
      it { expect { Paysera::Request.build_request(invalid_request, sign_password) }.to raise_error /orderid.+missing/ }
    end

    context 'when no accepturl given' do
      let (:invalid_request) { valid_request.delete(:accepturl); valid_request }
      it { expect { Paysera::Request.build_request(invalid_request, sign_password) }.to raise_error /accepturl.+missing/ }
    end

    context 'when no cancelurl given' do
      let (:invalid_request) { valid_request.delete(:cancelurl); valid_request }
      it { expect { Paysera::Request.build_request(invalid_request, sign_password) }.to raise_error /cancelurl.+missing/ }
    end

    context 'when no callbackurl given' do
      let (:invalid_request) { valid_request.delete(:callbackurl); valid_request }
      it { expect { Paysera::Request.build_request(invalid_request, sign_password) }.to raise_error /callbackurl.+missing/ }
    end

    context 'when no sign_password given' do
      it { expect { Paysera::Request.build_request(valid_request, nil) }.to raise_error /sign_password.+missing/ }
    end

    context 'when valid' do
      it { expect(subject).to match(/^https:\/\/(www\.)*(mokejimai|paysera)\.(lt|com)\/pay\/*\?(data|sign)=.+&(data|sign)=.+$/i) }
    end

    context 'when generated url params are valid' do
      let(:request) { Hash[subject.split('?')[1].split('&').map { |a| k=a.split('='); [k[0].to_sym, CGI.unescape(k[1]).gsub('+', '-').gsub('/', '_')] }] }

      it { expect(Digest::MD5.hexdigest(request[:data] + sign_password)).to eq(request[:sign]) }
    end
  end
end