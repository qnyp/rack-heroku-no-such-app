module Rack
  module Heroku
    class NoSuchApp
      VERSION = "0.0.2"

      HEROKUAPP_DOMAIN_REGEXP = /.+\.heroku(app)?\.com/

      def initialize(app)
        @app = app
      end

      def call(env)
        if HEROKUAPP_DOMAIN_REGEXP === (env['HTTP_HOST'] || env['SERVER_NAME'])
          return [404, headers, [body]]
        end

        @app.call(env)
      end

      private

      def headers
        {
          'Content-Type'  => 'text/html',
          'Server' => 'Cowboy'
        }
      end

      def body
        <<-EOF
<!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>No such app</title>
        <style media="screen">
          html,body,iframe {
            margin: 0;
            padding: 0;
          }
          html,body {
            height: 100%;
            overflow: hidden;
          }
          iframe {
            width: 100%;
            height: 100%;
            border: 0;
          }
        </style>
      </head>
      <body>
        <iframe src="//www.herokucdn.com/error-pages/no-such-app.html"></iframe>
      </body>
    </html>
      EOF
      end
    end
  end
end
