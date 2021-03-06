require 'abstract_unit'

module ActionDispatch
  class UploadedFileTest < ActiveSupport::TestCase
    def test_constructor_with_argument_error
      assert_raises(ArgumentError) do
        Http::UploadedFile.new({})
      end
    end

    def test_original_filename
      uf = Http::UploadedFile.new(:filename => 'foo', :tempfile => Object.new)
      assert_equal 'foo', uf.original_filename
    end

    def test_content_type
      uf = Http::UploadedFile.new(:type => 'foo', :tempfile => Object.new)
      assert_equal 'foo', uf.content_type
    end

    def test_headers
      uf = Http::UploadedFile.new(:head => 'foo', :tempfile => Object.new)
      assert_equal 'foo', uf.headers
    end

    def test_tempfile
      uf = Http::UploadedFile.new(:tempfile => 'foo')
      assert_equal 'foo', uf.tempfile
    end

    def test_delegates_to_tempfile
      tf = Class.new { def read; 'thunderhorse' end }
      uf = Http::UploadedFile.new(:tempfile => tf.new)
      assert_equal 'thunderhorse', uf.read
    end

    def test_delegates_to_tempfile_with_params
      tf = Class.new { def read *args; args end }
      uf = Http::UploadedFile.new(:tempfile => tf.new)
      assert_equal %w{ thunder horse }, uf.read(*%w{ thunder horse })
    end

    def test_delegate_respects_respond_to?
      tf = Class.new { def read; yield end; private :read }
      uf = Http::UploadedFile.new(:tempfile => tf.new)
      assert_raises(NoMethodError) do
        uf.read
      end
    end

    def test_respond_to?
      tf = Class.new { def read; yield end }
      uf = Http::UploadedFile.new(:tempfile => tf.new)
      assert uf.respond_to?(:headers), 'responds to headers'
      assert uf.respond_to?(:read), 'responds to read'
    end
  end
end
