module DropFileHelper
  def drop_file(locator, *args)
    element_id = "dropybara_input_#{rand(1000)}"

    execute_script <<-JS
      var input = document.createElement('input');
      input.setAttribute('type', 'file');
      input.setAttribute('id', '#{element_id}')
      document.body.appendChild(input);
    JS

    attach_file(element_id, *args).tap do
      execute_script <<-JS
        var input = document.getElementById('#{element_id}');
        var target = document.querySelector('#{locator}');
        var data = new DataTransfer();
        data.files = input.files;
        data.items.add(input.files[0]);
        data.types = ['Files'];

        var event = new DragEvent('drop', {
          target: target,
          dataTransfer: data
        });
        target.dispatchEvent(event);

        document.body.removeChild(input);
      JS
    end
  end
end


RSpec.configure do |config|
  config.include DropFileHelper, type: :feature
end
