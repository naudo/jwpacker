require "nokogiri"
require "active_support"

file = File.open(ARGV[0])

parsed = Nokogiri.XML(file)
puts Nokogiri.XML(file).inspect

parsed.xpath("//components/component/@name").each do |component|
  component_name = component.value
  parsed.xpath("//components/component[@name='#{component_name}']")

  component.xpath("//element/@src").each do |element|
    file_path = File.join( File.dirname(file),"#{component_name}/#{element.value}")
    begin
      data_uri_base_string = "data:image/png;base64,"

      if element.value.slice(0,data_uri_base_string.length) != data_uri_base_string
        image_file = File.read(file_path)
        data = ActiveSupport::Base64.encode64(image_file).gsub("\n", '')
        data_uri_string = "#{data_uri_string}#{data}"
        element.value = data_uri_string
      else
        puts "Image already packed"
      end
    rescue
      puts "No File for #{file_path}"
    end
  end
end

File.open('skin.xml','w') {|f| parsed.write_xml_to f}