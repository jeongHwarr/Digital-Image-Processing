clear all;

% choose a file
[file,path] = uigetfile('*.avi');
[filepath,name,ext] = fileparts(file);

vidobj = VideoReader(file);
numFrames = get(vidobj, 'NumberOfFrames');

%% [a] averaging operation without frame alignment

for i = 1 : numFrames
    frame = im2double(read(vidobj, i));

    if i==1
        frame_average = frame;
        first_frame = frame;
    else
        frame_average = ((i-1)/i*frame_average)+((1/i)*frame);    
    end

    % disp(frame(:,:,1));
    % disp(frame_average(:,:,1));

    output_dir_2_a = fullfile(path,'output','2_a');
    mkdir(output_dir_2_a);

    if i==30
        subplot(1,2,1), imshow(first_frame);
        subplot(1,2,2), imshow(frame_average);
        truesize 
        
        imwrite(first_frame,fullfile(output_dir_2_a,strcat(name,'_average_1','.png')));
        imwrite(frame_average,fullfile(output_dir_2_a,strcat(name,'_average_',num2str(i,'%2d'),'.png')));
        
        break

    end
end % i

%% [b] averaging operation wit frame alignment

% initial range
dx_range = -1 : 0.5 : 1;
dy_range = -1 : 0.5 : 1;

for i = 1 : numFrames
    frame = im2double(read(vidobj, i));    
   
    if i==1
        frame_average_align = frame;
        first_frame = frame;
        
    else
        [align_result,best_dx,best_dy] = align(frame_average_align,frame,dx_range,dy_range);
        frame_average_align = ((i-1)/i*frame_average_align)+((1/i)*align_result);    
   
        subplot(1,3,1), imshow(frame);
        subplot(1,3,2), imshow(align_result);
        subplot(1,3,3), imshow(frame_average_align);
        truesize 
        
        dx_range = best_dx-1 : 0.5 : best_dx+1;
        dy_range = best_dy-1 : 0.5 : best_dy+1;
    end
    
    output_dir_2_b = fullfile(path,'output','2_b');
    mkdir(output_dir_2_b);

    if i==30
        subplot(1,2,1), imshow(first_frame);
        subplot(1,2,2), imshow(frame_average_align);
        truesize 
        
        imwrite(first_frame,fullfile(output_dir_2_b,strcat(name,'_average_1','.png')));
        imwrite(frame_average_align,fullfile(output_dir_2_b,strcat(name,'_average_',num2str(i,'%2d'),'.png')));
        
        break

    end
end % i

function [result,best_dx,best_dy] = align(reference,current,dx_range,dy_range)
    
    best_msd = inf;
    
    gray_reference = rgb2gray(reference);
    gray_current = rgb2gray(current);
    [height,width,channels] = size(reference);
    
    for dy = dy_range
        for dx = dx_range
            A = [1 0 dx; 0 1 dy; 0 0 1];
            tform = maketform('affine', A.');
            gray_frameTform = imtransform(gray_current, tform, 'bilinear', 'Xdata' , [1 width], 'YData', [1 height], 'FillValues', 0);
            
            msd = sum(sum(power(gray_reference-gray_frameTform,2)));
            
            if msd < best_msd
                best_msd = msd;
                best_dx = dx;
                best_dy = dy;
            end
        end
    end
    
    A = [1 0 best_dx; 0 1 best_dy; 0 0 1];
    tform = maketform('affine', A.');
    result = imtransform(current, tform, 'bilinear', 'Xdata' , [1 width], 'YData', [1 height], 'FillValues', zeros(channels,1));
       
end


