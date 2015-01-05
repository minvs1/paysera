class Paysera::Attributes
    SMS = {
        :to        => {},
        :sms       => {},
        :from      => {},
        :operator  => {},
        :amount    => {
            :maxlen   => 11,
            :required => false,
            :regex    => /^\d+$/
        },
        :currency  => {
            :maxlen   => 3,
            :required => false,
            :regex    => /^[a-z]{3}$/i
        },
        :country   => {
            :maxlen   => 2,
            :required => false,
            :regex    => /^[a-z]{2}$/i
        },
        :id        => {},
        :test      => {
            :maxlen   => 1,
            :required => false,
            :regex    => /^[01]$/
        },
        :key       => {},
        :projectid => {
            :maxlen   => 11,
            :required => true,
            :regex    => /^\d+$/
        },
        :version   => {
            :maxlen   => 9,
            :required => true,
            :regex    => /^\d+\.\d+$/
        }
    }

    REQUEST = {
      :projectid         => {
          :maxlen   => 11,
          :required => true,
          :regex    => /^\d+$/
      },
      :orderid     => {
          :maxlen   => 40,
          :required => true,
          :regex    => /^\d+$/
      },
      :accepturl   => {
          :maxlen   => 255,
          :required => true,
      },
      :cancelurl   => {
          :maxlen   => 255,
          :required => true,
      },
      :callbackurl => {
          :maxlen   => 255,
          :required => true,
      },
      :version           => {
          :maxlen   => 9,
          :required => true,
          :regex    => /^\d+\.\d+$/
      },
      :lang              => {
          :maxlen   => 3,
          :required => false,
          :regex    => /^[a-z]{3}$/i
      },
      :amount            => {
          :maxlen   => 11,
          :required => false,
          :regex    => /^\d+$/
      },
      :currency          => {
          :maxlen   => 3,
          :required => false,
          :regex    => /^[a-z]{3}$/i
      },
      :payment           => {
          :maxlen   => 20,
          :required => false
      },
      :country           => {
          :maxlen   => 2,
          :required => false,
          :regex    => /^[a-z]{2}$/i
      },
      :paytext           => {
          :maxlen   => 255,
          :required => false,
      },
      :p_firstname       => {
          :maxlen   => 255,
          :required => false,
      },
      :p_lastname        => {
          :maxlen   => 255,
          :required => false,
      },
      :p_email           => {
          :maxlen   => 255,
          :required => false,
      },
      :p_street          => {
          :maxlen   => 255,
          :required => false,
      },
      :p_city            => {
          :maxlen   => 255,
          :required => false,
      },
      :p_state           => {
          :maxlen   => 20,
          :required => false,
      },
      :p_zip             => {
          :maxlen   => 20,
          :required => false,
      },
      :p_countrycode     => {
          :maxlen   => 2,
          :required => false,
          :regex    => /^[a-z]{2}$/i
      },
      :only_payments     => {
          :required => false,
      },
      :disallow_payments => {
          :required => false,
      },
      :test              => {
          :maxlen   => 1,
          :required => false,
          :regex    => /^[01]$/
      },
      :time_limit        => {
          :maxlen   => 19,
          :required => false,
      },
      :personcode        => {
          :maxlen   => 255,
          :required => false,
      },
      :developerid       => {
          :maxlen   => 11,
          :required => false,
          :regex    => /^\d+$/
      }
  }
end