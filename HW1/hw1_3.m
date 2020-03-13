clear all;

[file,path] = uigetfile('*_reference.jpg');
[filepath,name,ext] = fileparts(file);

split_file = split(file,'_reference');
tampered_name = strcat(char(split_file(1)),'_tampered',char(split_file(2)));

reference = im2double(imread(file));
tampered = im2double(imread(tampered_name));

gray_reference = rgb2gray(reference);
gray_tampered = rgb2gray(tampered);

%% without image alignment
difference = abs(gray_reference-gray_tampered);
binary_difference_unalign = imbinarize(difference,0.2);

%% with image alignment

dx_range = -3 : 0.5 : 3;
dy_range = -3 : 0.5 : 3;
best_msd = inf;

[height,width,channels] = size(gray_reference);

for dy = dy_range
    for dx = dx_range
        A = [1 0 dx; 0 1 dy; 0 0 1];
        tform = maketform('affine', A.');
        gray_frameTform = imtransform(gray_tampered, tform, 'bilinear', 'Xdata' , [1 width], 'YData', [1 height], 'FillValues', channels);

        msd = sum(sum(power(gray_reference-gray_frameTform,2)));

        if msd < best_msd
            best_msd = msd;
            best_dx = dx;
            best_dy = dy;
            gray_tampered_align = gray_frameTform;
        end
    end
end

fprintf('Best dx = %.2f, dy = %.2f\n', best_dx, best_dy);
difference_align = abs(gray_reference-gray_tampered_align);
binary_difference_align = imbinarize(difference_align,0.1);

subplot(1,2,1), imshow(binary_difference_unalign);
subplot(1,2,2), imshow(binary_difference_align);
truesize;

output_dir_3 = fullfile(path,'output','3');
mkdir(output_dir_3);

imwrite(binary_difference_unalign,fullfile(output_dir_3,strcat(char(split_file(1)),'_unalign','.png')));
imwrite(binary_difference_align,fullfile(output_dir_3,strcat(char(split_file(1)),'_align','.png')));
truesize 




