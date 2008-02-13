#!/usr/bin/ruby
# Rugelach v0.1
# Displays the wireless signal strength of wireless connections in
# the GNOME/KDE Notification Area
#
# Requires: libgtk2-ruby, sysfs, network-manager icons
#
# (c) 2007 Ari Pollak
# You may not look at this program.

POLLDELAY = 1 # in seconds
DEVICE = 'eth1'

require 'gtk2'
require 'socket'

class LogiTray < Gtk::StatusIcon
    NM_ICON_PATH = '/usr/share/icons/hicolor/22x22/apps'
    NO_CONN_ICON = NM_ICON_PATH + '/nm-no-connection.png'
    SIGNAL_ICONS = NM_ICON_PATH + '/nm-signal-#.png'
    SIOCGIWESSID = 0x8B1B # From /usr/include/linux/wireless.h

    def initialize
        super()
        signal_connect("activate", &method(:click_handler))
        signal_connect("popup-menu", &method(:menu_handler))

        @menu = Gtk::Menu.new
        item = Gtk::ImageMenuItem.new(Gtk::Stock::QUIT)
        item.signal_connect('activate') { Gtk.main_quit }
        @menu.append(item)
        @menu.show_all
    end

    def run
        update_info()
        Gtk.timeout_add(POLLDELAY * 1000, &method(:update_info))
        
        Gtk.main()
    end

    def click_handler(icon)
        # TODO: I don't think this ever gets called on a left-click
        update_info()
    end

    def menu_handler(widget, button, activate_time)
        @menu.popup(nil, nil, button, activate_time) { |menu, x, y, push_in|
            position_menu(menu)
        }
    end


    def update_info
        begin
            File.open("/sys/class/net/#{DEVICE}/device/status") { |io|
                status = io.read_nonblock(10).strip
                if status[-2..-1] != 'e2'
                    update_output("Interface #{DEVICE} is offline")
                    self.file = NO_CONN_ICON
                    return true
                end
            }

            File.open("/sys/class/net/#{DEVICE}/wireless/link") { |io|
                level = io.read_nonblock(3).strip
                output = "Signal strength: " + level
                output += "\n" + get_essid()
                update_output(output)
                update_level(level)
            }
        rescue => e
            output = "Error getting info for device #{DEVICE}: " + e
            self.stock = Gtk::Stock::DIALOG_ERROR
            update_output(output)
        end

        return true
    end

    def get_essid
        sock = UDPSocket.new
        str = ['eth1', "\0" * 32, 32, 0].pack('a16pSS')
        sock.ioctl(SIOCGIWESSID, str)
        ifrn_name, pointer, length, flags = str.unpack('a16pSS')

        return pointer[0,length]
    end

    def update_output(output)
        if @prev_output != output
            self.tooltip = output
            @prev_output = output
        end
    end

    def update_level(level)
        num = nil
        case level.to_i
            when 1..25   then num = '25'
            when 26..50  then num = '50'
            when 51..75  then num = '75'
            when 76..100 then num = '100'
            else              num = '00'
        end
        self.file = SIGNAL_ICONS.sub('#', num)
    end

end


tray = LogiTray.new
tray.run()

# vim: set et ts=4 sts=4 sw=4:
