require 'spec_helper'

describe Paysera::Response do

  # TODO: add sms response
  let(:response_data) do
    {
        :data => 'b3JkZXJpZD0xMjM0JnByb2plY3RpZD01NjU3MSZ0ZXN0PTEmdmVyc2lvbj0xLjYmdHlwZT1URVNUJmxhbmc9JnBheW1lbnQ9aGFuemEmY3VycmVuY3k9TFRMJmFtb3VudD0xMDAwMDAmcGF5dGV4dD1PcmRlcitObyUzQSsxMjM0K2F0K2h0dHAlM0ElMkYlMkZwYXlzZXJhLndwci5sdCtwcm9qZWN0LislMjhTZWxsZXIlM0ErVG9tYXMrQWNobWVkb3ZhcyUyOSZwX2VtYWlsPXRyeWtpejExJTQwZ21haWwuY29tJmNvdW50cnk9TFQmbV9wYXlfcmVzdG9yZWQ9MHg0Jl9jbGllbnRfbGFuZ3VhZ2U9ZW5nJnJlY2VpdmVyaWQ9MTg2NTA2JnN0YXR1cz0xJnBheWFtb3VudD0xMDAwMDAmcGF5Y3VycmVuY3k9TFRMJnJlcXVlc3RpZD02OTk0MzY5NyZuYW1lPSZzdXJlbmFtZT0%3D',
        :ss1  => '0a58f2b1fe7972e616a01150427f7912',
        :ss2  => '02pTV2VtdxJlMIdrKakCHpIxgiG--1iUwZkxikwAvqPEiiEj_ekmMYsnYDu3B8RlrmDBWrsSIRLIaPwOGLbInQc9vduK3lsjm9PQ9RImNXEHcc5Pyk-6cQ93U833bQ73r5NxvwfxE8s3KhBUxwHDLTSPCMnF7yEhskLx63I0SW8%3D'
    }
  end
  let(:another_response_data) do
    {
        :data => 'YW1vdW50PTIwMCZjb3VudHJ5PUxUJmN1cnJlbmN5PUVVUiZsYW5nPWxpdCZvcmRlcmlkPTMwMTAyMDAwMTQyNzc1Mjk0NCZwX2NvdW50cnljb2RlPUxUJnBheXRleHQ9QXBtb2slQzQlOTdqaW1hcyt1JUM1JUJFKzEra3JlZC4rJTI4aHR0cCUzQSUyRiUyRmxvY2FsaG9zdCt1JUM1JUJFc2FreW1hcyszMDEwMjAwMDE0Mjc3NTI5NDQlMjkmcHJvamVjdGlkPTU2NTcxJnRlc3Q9MSZ2ZXJzaW9uPTEuNiZwYXltZW50PWhhbnphJnBfZW1haWw9c29ycnklMkJqdXN0JTJCdGVzdGluZyUyQnBheXNlcmElMkJnZW0lNDBnbWFpbC5jb20mc3RhdHVzPTEmcmVxdWVzdGlkPTc1MzcxMDU0JnBheWFtb3VudD0yMDAmcGF5Y3VycmVuY3k9RVVS',
        :ss1  => '3a3ce55cfdf7e950a766cd6df6693f95',
        :ss2  => '3TKdk3iLGkMEvBW-NNl5i5y0wHEaXMZt2cLwBnxsPO8Jsf_PVfHsoN-eWYMFQFrpHXgZTqGwhCEhw3goAXIyFH8EW-jzNmMOoBVPjpMif7ZYRgerd1nI_pVz9_RAEXDd7WSvuhJz5se2F0UMgUikfVALdBEQ3UcrfYqKecUsmbU='
    }
  end
  let(:projectid) { 56571 }
  let(:sign_password) { '36947d6dcbccc03ad591deab138dbb0c' }

  subject(:bank_response) { Paysera::Response.new response_data, projectid: projectid, sign_password: sign_password }
  subject(:sms_response) { Paysera::Response.new response_data, projectid: projectid, sign_password: sign_password }

  describe '#initialize' do
    def new_response(data: nil, ss1: nil, ss2: nil, p_id: nil, sign: nil)
      Paysera::Response.new({ data: data, ss1: ss1, ss2: ss2 }, projectid: p_id, sign_password: sign)
    end

    context 'when no data param' do
      it { expect { new_response(ss1: 't', ss2: 't', p_id: 1, sign: 't') }.to raise_exception /data.+not\sfound/i }
    end

    context 'when no ss1 param' do
      it { expect { new_response(data: 't', ss2: 't', p_id: 1, sign: 't') }.to raise_exception /ss1.+not\sfound/i }
    end

    context 'when no ss2 param' do
      it { expect { new_response(data: 't', ss1: 't', p_id: 1, sign: 't') }.to raise_exception /ss2.+not\sfound/i }
    end

    context 'when no projectid param' do
      it { expect { new_response(data: 't', ss1: 't', ss2: 't', sign: 't') }.to raise_exception /projectid.+not\sfound/i }
    end

    context 'when no sign_password param' do
      it { expect { new_response(data: 't', ss1: 't', ss2: 't', p_id: 1) }.to raise_exception /sign_password.+not\sfound/i }
    end

    context 'when invalid ss1' do
      it { expect { new_response(data: response_data[:data],
                                 ss1:  't',
                                 ss2:  response_data[:ss2],
                                 p_id: projectid,
                                 sign: sign_password) }.to raise_exception /verify.+ss1/i }
    end

    context 'when invalid ss2' do
      it { expect { new_response(data: response_data[:data],
                                 ss1:  response_data[:ss1],
                                 ss2:  't',
                                 p_id: projectid,
                                 sign: sign_password) }.to raise_exception /verify.+ss2/i }
    end

    context 'when valid ss2' do
      it { expect { new_response(data: another_response_data[:data],
                                 ss1:  another_response_data[:ss1],
                                 ss2:  another_response_data[:ss2],
                                 p_id: projectid,
                                 sign: sign_password) }.not_to raise_error }

      it { expect { new_response(data: response_data[:data],
                                 ss1:  response_data[:ss1],
                                 ss2:  response_data[:ss2],
                                 p_id: projectid,
                                 sign: sign_password) }.not_to raise_error }
    end

    context 'when projectid mismatch' do
      it { expect { new_response(data: response_data[:data],
                                 ss1:  response_data[:ss1],
                                 ss2:  response_data[:ss2],
                                 p_id: 1,
                                 sign: sign_password) }.to raise_exception /projectid.+mismatch/i }
      it { expect { new_response(data: response_data[:data],
                                 ss1:  response_data[:ss1],
                                 ss2:  response_data[:ss2],
                                 p_id: 56571,
                                 sign: sign_password) }.not_to raise_error }
      it { expect { new_response(data: response_data[:data],
                                 ss1:  response_data[:ss1],
                                 ss2:  response_data[:ss2],
                                 p_id: "56571",
                                 sign: sign_password) }.not_to raise_error }
    end
  end

  describe '#bank?' do
    context 'when sms response' do
      it { expect(sms_response.bank?).to be false }
    end

    context 'when bank response' do
      it { expect(bank_response.bank?).to be true }
    end
  end

  describe '#sms?' do
    context 'when bank response' do
      it { expect(bank_response.sms?).to be false }
    end

    context 'when bank response' do
      it { expect(sms_response.sms?).to be true }
    end
  end

  describe '#get_data' do
    it { expect(bank_response.get_data).to be_kind_of(Hash) }
  end
end
