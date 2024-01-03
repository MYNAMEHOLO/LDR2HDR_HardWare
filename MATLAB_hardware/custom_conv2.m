% 使用2D卷積請利用這個自製函數，因為Matlab官方提出的Conv2會造成Kernel被反轉180度。
% 這邊的 output只取卷積出來的中間pxl值。
function output_1_pxl = custom_conv2(input, kernel)
    [m, n] = size(input);
    [km, kn] = size(kernel);
    
    % 计算核的中心位置偏移
    center = floor([km, kn] / 2);

    % 初始化输出矩阵
    output = zeros(size(input), 'like', input);
    
    % 对每个像素应用卷积核
    for i = 1:m
        for j = 1:n
            for ki = 1:km
                for kj = 1:kn
                    ii = i + ki - center(1) - 1;
                    jj = j + kj - center(2) - 1;
                    if ii > 0 && ii <= m && jj > 0 && jj <= n
                        output(i, j) = output(i, j) + input(ii, jj) * kernel(ki, kj);
                    end
                end
            end
        end
    end
    output_1_pxl = output(2,2);
end