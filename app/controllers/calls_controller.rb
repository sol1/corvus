require 'net/http'

class CallsController < ApplicationController

  before_filter :authenticate_user!
  before_action :set_call, only: [:show, :wav, :download]

  # GET /calls
  # GET /calls.json
  def index
    @title = "Calls"

    @date_from = Date.strptime(params[:date_from].to_s, '%d/%m/%Y') rescue nil
    @date_to   = Date.strptime(params[:date_to].to_s, '%d/%m/%Y') rescue nil

    @phone_field = %w[caller called any].include?(params[:s]) ? params[:s] : 'any'
    @phone_number = params[:p].to_s.gsub(/[^0-9]/, '')

    @calls = Call.set_current_user(current_user).all.paginate(:page => params[:page])
    @calls = @calls.where('calldate >= ?', "#{@date_from} 00:00:00") if @date_from
    @calls = @calls.where('calldate <= ?', "#{@date_to} 23:59:59") if @date_to

    unless @phone_number.blank?
      if @phone_field == 'any'
        @calls = @calls.joins(:called)
          @calls = @calls.where("(caller LIKE ? OR number LIKE ?)", "%#{@phone_number}%","%#{@phone_number}%")
      elsif @phone_field == 'caller'
        @calls = @calls.where("(#{@phone_field} LIKE ?)", "%#{@phone_number}%")
      else
        @calls = @calls.joins(:called).where("(number LIKE ?)", "%#{@phone_number}%")
      end
    end
  end

  # GET /calls/1
  # GET /calls/1.json
  def show
  end

  def download
    @disposition = 'attachment'
    wav
  end

  def wav
    @disposition ||= 'inline'

    # Use the VOIPmonitor getVoiceRecording by Cdr ID
    # https://www.voipmonitor.org/doc/WEB_API#getVoiceRecording_by_Cdr_ID
    tmpdir = Rails.root.join('tmp','wav')
    fname = tmpdir.join("#{@call.cdr_id}.wav").to_s
    Rails.logger.debug("Sourcing #{fname}")
    if !File.exists? tmpdir
      Rails.logger.debug("Creating #{tmpdir}")
      begin
        Dir.mkdir(tmpdir,0755)
      rescue
        # Unable to create - raise exception
        raise "Unable to create directory #{tmpdir}!"
      end
    elsif !File.directory? tmpdir
      # Exists but isn't a directory - raise exception
      raise "#{tmpdir} exists but is not a directory!"
    end

    # Only fetch remote file if we don't already have it in tmp/wav - this is needed for seeking/streaming to handle range requests correctly
    if !File.file?(fname)
      Rails.logger.debug("Downloading #{fname}")
      args = [
        "task=getVoiceRecording",
        "user=" + Rails.application.config.voipmonitor[:user],
        "password=" + Rails.application.config.voipmonitor[:password],
        "params={'cdrId': #{@call.cdr_id}}",
      ]

      args = Rails.application.config.voipmonitor[:baseurl] + "?" + args.join('&')

      url = URI.parse(args)
      req = Net::HTTP::Get.new(url)
      res = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}

      if res['content-type'].to_s.include?('audio')
        # If we receive audio back, save content to disk so we can process ranges correctly on subsequent requests
        Rails.logger.debug("Saving #{fname}")
        open(fname,'wb') {
          |fd|
          fd.write(res.body)
        }
      else
        # if (json = JSON.parse(res.body) rescue nil)
        # Any other response will probably be a JSON error from VOIPmonitor, pass it forward as-is.
        Rails.logger.debug("Did not receive audio from upstream server!")
        Rails.logger.debug(res.body.inspect)
        send_data(res.body, :type => res['content-type'], :disposition => 'inline') and return
      end
    end
    # (re)Read saved audio file and calculate initial range values - will be altered by browser range request
    Rails.logger.debug("Reading #{fname}")
    wavfile = open(fname)
    wavstart = 0
    wavsize = wavfile.size
    wavend = wavfile.size - 1
    # Either serve the whole file or partial content as browser requests
    if !request.headers["Range"]
      Rails.logger.debug("No range specified")
      status_code = "200 OK"
    else
      Rails.logger.debug("Will stream #{fname}")
      status_code = "206 Partial Content"
      match = request.headers['range'].match(/bytes=(\d+)-(\d*)/)
      if match
        wavstart = match[1].to_i
        wavend = match[2].to_i if match[2] && !match[2].empty?
      end
      response.header["Content-Range"] = "bytes " + wavstart.to_s + "-" + wavend.to_s + "/" + wavsize.to_s
    end
    response.header["Content-Length"] = (wavend - wavstart + 1).to_s
    # Send potentially partial data and ensure file descriptor is closed
    wavfile.seek(wavstart)
    wavdata = wavfile.read(wavend - wavstart + 1)
    wavfile.close()
    Rails.logger.debug("Sending #{fname}")
    send_data(wavdata, :type => MIME::Types.type_for(fname).first.content_type, :disposition => @disposition, :status => status_code, :filename => "#{@call.cdr_id}.wav") and return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_call
      @call = Call.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_params
      params[:call]
    end
end
