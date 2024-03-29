require "nokogiri"
require "base64"
require "debugger"

file = File.open(ARGV[0])

parsed = Nokogiri.XML(file)
# debugger;1
# parsed.xpath("//components/component/@name").each do |component|
#   component_name = component.value
#   parsed.xpath("//components/component[@name='#{component_name}']")

#   component.xpath("//element/@src").each do |element|
#     file_path = File.join( File.dirname(file),"#{component_name}/#{element.value}")
#     data_uri_base_string = "data:image/png;base64,"
#     data_uri_string = ""

#     if File.exists?(file_path)

#       if element.value.slice(0,data_uri_base_string.length) != data_uri_base_string
#       # if element.value !=~ /#{data_uri_base_string}/
#         image_file = File.read(file_path)
#         data = Base64.encode64(image_file).gsub("\n", '')
#         data_uri_string = "#{data_uri_base_string}#{data}"
#         puts "Packing #{file_path}"
#         element.value = data_uri_string
#       else
#         puts "Image already packed"
#       end

#     else

#       puts "No File for #{file_path}"
#     end
#   end
# end
parsed.xpath("//components/component/@name").each do |component|
  component_name = component.value
  data_uri_base_string = "data:image/png;base64,"

  component.xpath("//elements/element").each do |node|
    file_path = File.join( File.dirname(file), "#{component_name}/#{node["src"]}")

    if File.exists?(file_path)
      image_file = File.read(file_path)
      data = Base64.encode64(image_file).gsub("\n", '')

      node["src"] = "#{data_uri_base_string}#{data}"
      puts "Packed: #{file_path}"
    else
      puts "No file for #{file_path}"
    end
  end
end
File.open('skin.xml','w') {|f| parsed.write_xml_to f}