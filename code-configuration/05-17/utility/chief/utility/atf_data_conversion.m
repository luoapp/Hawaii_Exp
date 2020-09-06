function [time,time_data,db_data,phase_data]=aptf_data_conversion(demo_dir,file)
%function [tseries,time_data,db_data,phase_data]=aptf_data_conversion(Ddir,Dfile)
%callable function to return data from an aptf-created file
% tseries=times of individual data points, 
%time_data=actual time series of
% collected data, 
%db_data, phase data are from the FFT of the data.
%
% NOTE:  The demo data file was created by the data acquisition program
%        which is written in C-Language.  Strings are read in differently
%        than those created in HP BASIC.
%
% Author: G. Lau
%
% Edit date:  Feb 12, 2002
%             Feb 25, 2002 added title enhancement

% clear
if ~exist('demo_dir','var')
    demo_dir='';
end
if ~exist('file','var')
    file='';
end

rec_len = zeros(4,1);
actual_sfreq = zeros(4,1);
samp_ratio = zeros(4,1);
fft_freq_span = zeros(4,1);

samp_filter = zeros(4,1);
data_type = zeros(4,1);

input_atten = zeros(4,1);
input_gain = zeros(4,1);
output_gain = zeros(4,1);

input_mode = zeros(4,1);
coupling = zeros(4,1);
inp_offset_opt = zeros(4,1);
inp_offset_lev = zeros(4,1);
input_range = zeros(4,1);
anti_alias_filt = zeros(4,1);
delay = zeros(4,1);
receive_gain = zeros(4,1);

hyd_sens = zeros(4,1);
cal_factor = zeros(4,1);
old_sens = zeros(4,1);

desired_sfreq = zeros(4,1);
num_freq_pts = zeros(4,1);
time_int = zeros(4,1);
freq_int = zeros(4,1);

opfreq_index = zeros(4,1);
opfreq_valid = zeros(4,1);

spl_ref = zeros(4,1);

% Get the setup parameters
cur_path=demo_dir;
cur_file=file;
[file,demo_dir] = uigetfile([demo_dir,cur_file],'Select Demo Data File To Open or Cancel To Exit');
if file == 0
    disp('Action Cancelled.');
    demo_dir=cur_path;
    file=cur_file;
    tseries=[];
    time_data=[];
    db_data=[];
    phase_data=[];
    return
else
    if file(1)=='e'
        file=file(2:length(file));
    end
end

fid = fopen([demo_dir,'e',file],'r','b');            % IEEE Big Endian format
fseek(fid,0,'bof');

num_recs        = fread(fid,1,'double');
rev_num         = fread(fid,1,'double');
trigger_source  = fread(fid,1,'double');
src_freq        = fread(fid,1,'double');
pulse_width1    = fread(fid,1,'double');
src_level       = fread(fid,1,'double');

avg_mode        = fread(fid,1,'double');
num_avgs        = fread(fid,1,'double');
rep_rate        = fread(fid,1,'double');

switch rev_num
    case 0
        rec_len(1)      = fread(fid,1,'double');
        actual_sfreq(1) = fread(fid,1,'double');
        samp_ratio(1)   = fread(fid,1,'double');
        fft_freq_span(1)= fread(fid,1,'double');
        
        samp_filter(1)  = fread(fid,1,'double');
        data_type(1)    = fread(fid,1,'double');
        dontcare1       = fread(fid,1,'double');
        fft_window1     = fread(fid,1,'double');
        
        num_sc_chans    = fread(fid,1,'double');
        if num_sc_chans>=1
            for j=1:num_sc_chans
                input_atten(j)     = fread(fid,1,'double');
                input_gain(j)      = fread(fid,1,'double');
                output_gain(j)     = fread(fid,1,'double');
            end
        end
        
        num_digitizers    = fread(fid,1,'double');
        for j=1:num_digitizers
            input_mode(j)      = fread(fid,1,'double');
            coupling(j)        = fread(fid,1,'double');
            inp_offset_opt(j)  = fread(fid,1,'double');
            inp_offset_lev(j)  = fread(fid,1,'double');
            
            input_range(j)     = fread(fid,1,'double');
            anti_alias_filt(j) = fread(fid,1,'double');
            delay(j)           = fread(fid,1,'double');
            receive_gain(j)    = fread(fid,1,'double');
            
            old_sens(j)        = fread(fid,1,'double');
            cal_factor(j)      = fread(fid,1,'double');
        end
        if num_digitizers>=2
            for j=1:num_digitizers
                rec_len(j)         = rec_len(0);
                actual_sfreq(j)    = actual_sfreq(0);
                samp_ratio(j)      = samp_ratio(0);           
                fft_freq_span(j)   = fft_freq_span(0);     
                samp_filter(j)     = samp_filter(0);
                data_type(j)       = data_type(0);
            end   
        end
        wfm_gen = 0;
        awg_formula_num = 0;
        phase_update = 0;
    case {1,2,3,4,5}
        fft_window1     = fread(fid,1,'double');
        num_sc_chans    = fread(fid,1,'double');
        if num_sc_chans>=1
            for j=1:num_sc_chans
                input_atten(j)     = fread(fid,1,'double');
                input_gain(j)      = fread(fid,1,'double');
                output_gain(j)     = fread(fid,1,'double');
            end
        end
        
        num_digitizers    = fread(fid,1,'double');
        for j=1:num_digitizers
            rec_len(j)         = fread(fid,1,'double');
            actual_sfreq(j)    = fread(fid,1,'double');
            samp_ratio(j)      = fread(fid,1,'double');
            
            fft_freq_span(j)   = fread(fid,1,'double');     
            samp_filter(j)     = fread(fid,1,'double');
            data_type(j)       = fread(fid,1,'double');
            
            input_mode(j)      = fread(fid,1,'double');
            coupling(j)        = fread(fid,1,'double');
            inp_offset_opt(j)  = fread(fid,1,'double');
            inp_offset_lev(j)  = fread(fid,1,'double');
            
            input_range(j)     = fread(fid,1,'double');
            anti_alias_filt(j) = fread(fid,1,'double');
            delay(j)           = fread(fid,1,'double');
            receive_gain(j)    = fread(fid,1,'double');
            
            old_sens(j)        = fread(fid,1,'double');
            cal_factor(j)      = fread(fid,1,'double');
        end
        
        if rev_num>=3
            wfm_gen   = fread(fid,1,'double');
            awg_formula_num   = fread(fid,1,'double');
            if rev_num>=4
                lfm_fmin   = fread(fid,1,'double');
                lfm_fmax   = fread(fid,1,'double');
                if rev_num>=5
                    spl_ref   = fread(fid,4,'double');
                end
            end
        end
        
        if rev_num==1
            phase_update=0;
        else
            phase_update=1;
        end
end

% Assume for now that each waveform contain the same number of points
for k=1:num_recs
    for j=1:num_digitizers
        num_freq_pts(j)  = floor(rec_len(j)/2.56+1.1);
        desired_sfreq(j) = actual_sfreq(j)*samp_ratio(j);
        time_int(j)      = 1/desired_sfreq(j);
        freq_int(j)      = desired_sfreq(j)/rec_len(j);
    end
    
    if k==1
        time = [0:(rec_len(1)-1)]'*time_int(1);
        time_data   = zeros(rec_len(1),num_digitizers,num_recs);
        if nargout>=3
            db_data     = zeros(num_freq_pts(1),num_digitizers,num_recs);
            phase_data  = zeros(num_freq_pts(1),num_digitizers,num_recs);
        end
    end
    for j=1:num_digitizers
        time_data(:,j,k)  = fread(fid,rec_len(j),'double');
    end
    if nargout>=3
        for j=1:num_digitizers
            db_data(:,j,k)    = fread(fid,num_freq_pts(j),'double');
            phase_data(:,j,k) = fread(fid,num_freq_pts(j),'double');
        end
    end
    
    %     time_stamp = GetString(fid); % Use this for basic-generated strings
    time_stamp = fread(fid,22,'char'); % Use this for c-lang-generated strings
    doncare2   = fread(fid,2,'char');  % Get the line feed char and the null char and throwaway
    
end
if nargout>=3    db_data=db_data-3; % Conversion from pk dB to RMS dB
end


eofstat1 = feof(fid);           % Debug
eofvar   = fread(fid,1,'char'); % Debug
eofstat2 = feof(fid);           % Debug
fclose(fid);
