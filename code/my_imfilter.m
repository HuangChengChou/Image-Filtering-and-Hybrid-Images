
function output = my_imfilter(image, filter)
%Elapsed time is 1.170535 seconds.
filter_rows = size(filter, 1);
filter_cols = size(filter, 2);

half_filter_rows = floor(filter_rows/2);% half row of filter 
half_filter_cols = floor(filter_cols/2);% half col of filter

image_rows = size(image, 1);
image_cols = size(image, 2);
image_channels = size(image, 3);

image = padarray(image, [half_filter_rows, half_filter_cols]);

output = zeros(image_rows, image_cols, image_channels);% initial output size first

for channel = 1:image_channels
    for row = 1:image_rows
        for col = 1:image_cols
            output(row, col, channel) = sum(sum(image(row:row+filter_rows-1, col:col+filter_cols-1, channel) .* filter));
        end
    end

end

%{
%Elapsed time is 0.182343 seconds.
function filtered_image = my_imfilter(image, filter)
	image_size = size(image);
	filtered_image = zeros(image_size);                                         % allocate new image

	filter_reshape = reshape(filter, size(filter, 1) * size(filter, 2), 1);     % reshape filter into one column for element-wise multiplication

	x_pad = (size(filter, 1) - 1) / 2;                                          % determine proper x and y padding
	y_pad = (size(filter, 2) - 1) / 2;

	for channel = 1 : size(image, 3)
	    padded_channel_image = padarray(image(:, :, channel), [x_pad, y_pad]);  % pad image with zeros
	    
	    cols = im2col(padded_channel_image, size(filter));                      % convert image blocks the size of the filter to columns
	    filtered_cols = cols .* repmat(filter_reshape, 1, size(cols, 2));       % multiply each column by the filter elementwise

	    sum_vector = sum(filtered_cols, 1);                                     % sum each column of the matrix together
	    filtered_image(:, :, channel) = col2im(sum_vector, ...                  % convert values back to image blocks 
	        [1 1], image_size(:, 1:2));                                         % (now mapping each value to a single pixel)
	end
end
%}