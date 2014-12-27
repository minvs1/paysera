class Paysera::Attributes
  REQUEST = {
      :project_id       => {
          :maxlen   => 11,
          :required => true,
          :regex    => '/^\d+$/'
      },
      :order_id         => {
          :maxlen   => 40,
          :required => true,
          :regex    => '/^\d+$/'
      },
      :accept_url       => {
          :maxlen   => 255,
          :required => true,
          :regex    => ''
      },
      :cancel_url       => {
          :maxlen   => 255,
          :required => true,
          :regex    => ''
      },
      :callback_url     => {
          :maxlen   => 255,
          :required => true,
          :regex    => ''
      },
      :version          => {
          :maxlen   => 9,
          :required => true,
          :regex    => '/^\d+\.\d+$/'
      },
      :lang             => {
          :maxlen   => 3,
          :required => false,
          :regex    => '/^[a-z]{3}$/i'
      },
      :amount           => {
          :maxlen   => 11,
          :required => false,
          :regex    => '/^\d+$/'
      },
      :currency         => {
          :maxlen   => 3,
          :required => false,
          :regex    => '/^[a-z]{3}$/i'
      },
      :payment          => {
          :maxlen   => 20,
          :required => false,
          :regex    => ''
      },
      :country          => {
          :maxlen   => 2,
          :required => false,
          :regex    => '/^[a-z]{2}$/i'
      },
      :paytext          => {
          :maxlen   => 255,
          :required => false,
          :regex    => ''
      },
      :p_firstname      => {
          :maxlen   => 255,
          :required => false,
          :regex    => ''
      },
      :p_lastname       => {
          :maxlen   => 255,
          :required => false,
          :regex    => ''
      },
      :p_email          => {
          :maxlen   => 255,
          :required => false,
          :regex    => ''
      },
      :p_street         => {
          :maxlen   => 255,
          :required => false,
          :regex    => ''
      },
      :p_city           => {
          :maxlen   => 255,
          :required => false,
          :regex    => ''
      },
      :p_state          => {
          :maxlen   => 20,
          :required => false,
          :regex    => ''
      },
      :p_zip            => {
          :maxlen   => 20,
          :required => false,
          :regex    => ''
      },
      :p_countrycode    => {
          :maxlen   => 2,
          :required => false,
          :regex    => '/^[a-z]{2}$/i'
      },
      :only_payments    => {
          :required => false,
          :regex    => ''
      },
      :disalow_payments => {
          :required => false,
          :regex    => ''
      },
      :test             => {
          :maxlen   => 1,
          :required => false,
          :regex    => '/^[01]$/'
      },
      :time_limit       => {
          :maxlen   => 19,
          :required => false,
          :regex    => ''
      },
      :personcode       => {
          :maxlen   => 255,
          :required => false,
          :regex    => ''
      },
      :developerid      => {
          :maxlen   => 11,
          :required => false,
          :regex    => '/^\d+$/'
      }
  }
end
