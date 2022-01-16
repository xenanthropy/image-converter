# frozen_string_literal: true

require 'gtk3'
require 'rmagick'

# Converter class
class Converter
  include Magick

  builder_file = "#{__dir__}/converter.glade"

  # Construct a Gtk::Builder instance and load our UI description
  builder = Gtk::Builder.new(file: builder_file)

  # Connect signal handlers to the constructed widgets
  window = builder.get_object('window')
  window.signal_connect('destroy') { Gtk.main_quit }

  converted_window = builder.get_object('converted_window')
  converted_window.signal_connect('destroy') { converted_window.hide }

  file_path = ''
  file_chooser_button = builder.get_object('file_chooser')
  file_chooser_button.signal_connect('file-set') { file_path = file_chooser_button.filename }

  file_extension = ''
  combo_box = builder.get_object('combo_box')
  combo_box.signal_connect('changed') { file_extension = combo_box.active_text }

  save_path = ''
  folder_chooser_button = builder.get_object('folder_chooser')
  folder_chooser_button.signal_connect('file-set') { save_path = folder_chooser_button.filename }

  ok_button = builder.get_object('ok_button')
  ok_button.signal_connect('clicked') { converted_window.hide }

  button = builder.get_object('button')
  button.signal_connect('clicked') do
    if file_extension != '' && file_path != '' && save_path != ''
      file_array = file_path.split('/')
      file_name = file_array[-1].split('.')
      name_wo_extension = file_name[0]
      image = ImageList.new(file_path.to_s)
      image.write("#{save_path}/#{name_wo_extension}.#{combo_box.active_text.downcase}")
      converted_window.show_all
    end
  end

  Gtk.main
end

program = Converter.new
program
