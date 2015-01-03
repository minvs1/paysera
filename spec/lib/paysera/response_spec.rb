require 'spec_helper'

describe Paysera::Response do
  let(:response_data) do
    {
        :data => 'b3JkZXJpZD0xMjM0JnByb2plY3RpZD01NjU3MSZ0ZXN0PTEmdmVyc2lvbj0xLjYmdHlwZT1URVNUJmxhbmc9JnBheW1lbnQ9aGFuemEmY3VycmVuY3k9TFRMJmFtb3VudD0xMDAwMDAmcGF5dGV4dD1PcmRlcitObyUzQSsxMjM0K2F0K2h0dHAlM0ElMkYlMkZwYXlzZXJhLndwci5sdCtwcm9qZWN0LislMjhTZWxsZXIlM0ErVG9tYXMrQWNobWVkb3ZhcyUyOSZwX2VtYWlsPXRyeWtpejExJTQwZ21haWwuY29tJmNvdW50cnk9TFQmbV9wYXlfcmVzdG9yZWQ9MHg0Jl9jbGllbnRfbGFuZ3VhZ2U9ZW5nJnJlY2VpdmVyaWQ9MTg2NTA2JnN0YXR1cz0xJnBheWFtb3VudD0xMDAwMDAmcGF5Y3VycmVuY3k9TFRMJnJlcXVlc3RpZD02OTk0MzY5NyZuYW1lPSZzdXJlbmFtZT0%3D',
        :ss1  => '0a58f2b1fe7972e616a01150427f7912',
        :ss2  => '02pTV2VtdxJlMIdrKakCHpIxgiG--1iUwZkxikwAvqPEiiEj_ekmMYsnYDu3B8RlrmDBWrsSIRLIaPwOGLbInQc9vduK3lsjm9PQ9RImNXEHcc5Pyk-6cQ93U833bQ73r5NxvwfxE8s3KhBUxwHDLTSPCMnF7yEhskLx63I0SW8%3D'
    }
  end

  let(:project_id) { 56571 }
  let(:sign_password) { '36947d6dcbccc03ad591deab138dbb0c' }

  subject { Paysera::Response.new response_data, project_id: project_id, sign_password: sign_password }

  describe '#initialize' do
    def new_response(data: nil, ss1: nil, ss2: nil, p_id: nil, sign: nil)
      Paysera::Response.new({ data: data, ss1: ss1, ss2: ss2 }, project_id: p_id, sign_password: sign)
    end

    context 'No arguments' do
      it 'raises data parameter was not found' do
        expect { new_response(ss1: 't', ss2: 't', p_id: 1, sign: 't') }.to raise_exception /data.+not\sfound/i
      end

      it 'raises ss1 parameter was not found' do
        expect { new_response(data: 't', ss2: 't', p_id: 1, sign: 't') }.to raise_exception /ss1.+not\sfound/i
      end

      it 'raises ss2 parameter was not found' do
        expect { new_response(data: 't', ss1: 't', p_id: 1, sign: 't') }.to raise_exception /ss2.+not\sfound/i
      end

      it 'raises projectid parameter was not found' do
        expect { new_response(data: 't', ss1: 't', ss2: 't', sign: 't') }.to raise_exception /projectid.+not\sfound/i
      end

      it 'raises sign_password parameter was not found' do
        expect { new_response(data: 't', ss1: 't', ss2: 't', p_id: 1) }.to raise_exception /sign_password.+not\sfound/i
      end
    end

    context 'Unverified arguments' do
      it 'raises ss1 unable to verify' do
        expect { new_response(data: response_data[:data],
                              ss1:  't',
                              ss2:  response_data[:ss2],
                              p_id: project_id,
                              sign: sign_password) }.to raise_exception /verify.+ss1/i
      end

      it 'raises ss2 unable to verify' do
        expect { new_response(data: response_data[:data],
                              ss1:  response_data[:ss1],
                              ss2:  't',
                              p_id: project_id,
                              sign: sign_password) }.to raise_exception /verify.+ss2/i
      end
    end


  end
end