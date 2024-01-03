%% for weight c2
function [output_onepxl_combined] = ROAD2(input_cell_R,input_cell_G,input_cell_B)
    output_onepxl_combined = zeros(1, 3);
    %% Define medium origin cell
    medium_pxl_origin_R = single(input_cell_R(2,2));
    medium_pxl_origin_G = single(input_cell_G(2,2));
    medium_pxl_origin_B = single(input_cell_B(2,2));

    %% 定義定點數的最小精度是二進制的小數點後第幾位
    fractionLength = 16;

    %% Define up road kernel
    Kernel1_1 = single([
        [ 0.01047998 ,-0.1124109  , 0.1168866 ];
        [-0.10314015 , 0.04120087 ,-0.05677121];
        [-0.00082199 , 0.02890181 ,-0.08626994];
        [-0.00922314 ,-0.09906567 ,-0.15294656];
        [ 0.08526406 ,-0.0401655  ,-0.11239073];
        [-0.1373133  ,-0.09539951 ,-0.08536857];
        [-0.10767062 ,-0.04511955 ,-0.11523796];
        [ 0.0184323  ,-0.08538943 ,-0.03800615];
        [-0.05865692 ,-0.09549294 , 0.01087021]
    ]);
    
    Kernel1_2 = single([
        [-0.11954749 ,-0.07182535, -0.06568448];
        [ 0.05461452 ,-0.09402728, -0.10374841];
        [ 0.06796602 ,-0.06041493, -0.00726971];
        [-0.00476594 ,-0.0870354 , -0.09720466];
        [-0.04389616 ,-0.0038997 , -0.03745915];
        [-0.04521634 , 0.11708529,  0.07160257];
        [-0.08374895 ,-0.07726027, -0.17625828];
        [ 0.07268994 , 0.08679567, -0.21907309];
        [ 0.05988217 ,-0.01293883, -0.16911802]
    ]);
    
    Kernel1_3 = single([
        [-0.03491731, -0.06059582, -0.06585759];
        [-0.0729439 ,  0.03275368, -0.20738278];
        [ 0.02816365, -0.11410002, -0.09543315];
        [ 0.02990897,  0.00170002,  0.0341342 ];
        [-0.00873811,  0.03668281, -0.11712805];
        [-0.20671825, -0.12040369, -0.0334686 ];
        [ 0.04153879, -0.15048768,  0.01503985];
        [-0.10605274, -0.02129663, -0.05378493];
        [-0.06566075, -0.14107104,  0.07164412]
    ]);
    
    %% 將Kernel中的數值轉換成為定點數
    Kernel1_1 = convertToFixedPoint(Kernel1_1, fractionLength);
    Kernel1_2 = convertToFixedPoint(Kernel1_2, fractionLength);
    Kernel1_3 = convertToFixedPoint(Kernel1_3, fractionLength);

    % 將原始 kernels 重新排列成三個獨立的通道
    kernel_1_1_R = reshape(Kernel1_1(:, 1)', 3, 3)';
    kernel_1_1_G = reshape(Kernel1_1(:, 2)', 3, 3)';
    kernel_1_1_B = reshape(Kernel1_1(:, 3)', 3, 3)';
    
    kernel_1_2_R = reshape(Kernel1_2(:, 1)', 3, 3)';
    kernel_1_2_G = reshape(Kernel1_2(:, 2)', 3, 3)';
    kernel_1_2_B = reshape(Kernel1_2(:, 3)', 3, 3)';
    
    kernel_1_3_R = reshape(Kernel1_3(:, 1)', 3, 3)';
    kernel_1_3_G = reshape(Kernel1_3(:, 2)', 3, 3)';
    kernel_1_3_B = reshape(Kernel1_3(:, 3)', 3, 3)';
    
    
%     % 顯示結果
%     disp('Kernel 1 for Red Channel (kernel_1_1_R):');
%     disp(kernel_1_1_R);
%     disp('Kernel 1 for Green Channel (kernel_1_1_G):');
%     disp(kernel_1_1_G);
%     disp('Kernel 1 for Blue Channel (kernel_1_1_B):');
%     disp(kernel_1_1_B);
%     
%     disp('Kernel 2 for Red Channel (kernel_1_2_R):');
%     disp(kernel_1_2_R);
%     disp('Kernel 2 for Green Channel (kernel_1_2_G):');
%     disp(kernel_1_2_G);
%     disp('Kernel 2 for Blue Channel (kernel_1_2_B):');
%     disp(kernel_1_2_B);
%     
%     
%     
%     disp('Kernel 3 for Red Channel (kernel_1_3_R):');
%     disp(kernel_1_3_R);
%     disp('Kernel 3 for Green Channel (kernel_1_3_G):');
%     disp(kernel_1_3_G);
%     disp('Kernel 3 for Blue Channel (kernel_1_3_B):');
%     disp(kernel_1_3_B);
    
    %% Define up road biases
    % biases
    biases_up_R = single(-0.04161078);
    biases_up_G = single(-0.06620801);
    biases_up_B = single(-0.05071963);
    
    % 將bias轉成定點數
    biases_up_R = floatToFixedPoint(biases_up_R, fractionLength);
    biases_up_G = floatToFixedPoint(biases_up_G, fractionLength);
    biases_up_B = floatToFixedPoint(biases_up_B, fractionLength);
    
%     % 顯示變數的數值
%     disp('biases_up_R:');
%     disp(biases_up_R);
%     
%     disp('biases_up_G:');
%     disp(biases_up_G);
%     
%     disp('biases_up_B:');
%     disp(biases_up_B);
    
    %% Define down road kernel
    Kernel2_1 = single([
        [-0.06630364,  0.03970648, -0.12777504];
        [-0.00901487,  0.00698216, -0.05492386];
        [-0.09286492, -0.03073472, -0.1727526 ];
        [ 0.03419495, -0.01773147, -0.18460867];
        [-0.08734487, -0.0685217 , -0.08078264];
        [ 0.02835958, -0.01206097, -0.01911482];
        [-0.05546559, -0.10808124,  0.04622684];
        [ 0.07756218, -0.17713861,  0.09611217];
        [ 0.09159161,  0.02967542, -0.05890389]
    ]);
    
    Kernel2_2 = single([
        [-0.02496909, -0.0590939  ,-0.02675531];
        [ 0.03424502, -0.09505775 ,-0.07545543];
        [-0.16062804, -0.05837722 ,-0.02336823];
        [-0.13587055, -0.04638942 ,-0.01933922];
        [ 0.05957095, -0.00590593 , 0.02139432];
        [-0.09680866,  0.07762852 ,-0.10278191];
        [-0.03819341, -0.0392319  ,-0.17237186];
        [-0.08097856,  0.1075671  , 0.10120207];
        [ 0.10648315, -0.21098292 , 0.05349647]
    ]);
    
    Kernel2_3 = single([
        [ 0.07427488, -0.06754062, -0.03562306];
        [ 0.02509467, -0.20105205,  0.05726716];
        [-0.20674634, -0.10811277,  0.04774075];
        [-0.16594322, -0.12335105, -0.11482473];
        [ 0.13370945, -0.01407092,  0.03245667];
        [-0.14072731,  0.01186798,  0.08283702];
        [-0.03953232, -0.05262988, -0.16315062];
        [-0.12689301, -0.07910828, -0.03017108];
        [ 0.17697711, -0.06939032, -0.05628887]
    ]);
    
    %% 將kernel中的數值轉換成定點數
    Kernel2_1 = convertToFixedPoint(Kernel2_1, fractionLength);
    Kernel2_2 = convertToFixedPoint(Kernel2_2, fractionLength);
    Kernel2_3 = convertToFixedPoint(Kernel2_3, fractionLength);

    % 將原始 kernels 重新排列成三個獨立的通道
    kernel_2_1_R = reshape(Kernel2_1(:, 1)', 3, 3)';
    kernel_2_1_G = reshape(Kernel2_1(:, 2)', 3, 3)';
    kernel_2_1_B = reshape(Kernel2_1(:, 3)', 3, 3)';
    
    kernel_2_2_R = reshape(Kernel2_2(:, 1)', 3, 3)';
    kernel_2_2_G = reshape(Kernel2_2(:, 2)', 3, 3)';
    kernel_2_2_B = reshape(Kernel2_2(:, 3)', 3, 3)';
    
    kernel_2_3_R = reshape(Kernel2_3(:, 1)', 3, 3)';
    kernel_2_3_G = reshape(Kernel2_3(:, 2)', 3, 3)';
    kernel_2_3_B = reshape(Kernel2_3(:, 3)', 3, 3)';
    
    
%     % 顯示結果
%     disp('Kernel 2-1 for Red Channel (kernel_2_1_R):');
%     disp(kernel_2_1_R);
%     disp('Kernel 2-1 for Green Channel (kernel_2_1_G):');
%     disp(kernel_2_1_G);
%     disp('Kernel 2-1 for Blue Channel (kernel_2_1_B):');
%     disp(kernel_2_1_B);
%     
%     disp('Kernel 2-2 for Red Channel (kernel_2_2_R):');
%     disp(kernel_2_2_R);
%     disp('Kernel 2-2 for Green Channel (kernel_2_2_G):');
%     disp(kernel_2_2_G);
%     disp('Kernel 2-2 for Blue Channel (kernel_2_2_B):');
%     disp(kernel_2_2_B);
%     
%     disp('Kernel 2-3 for Red Channel (kernel_2_3_R):');
%     disp(kernel_2_3_R);
%     disp('Kernel 2-3 for Green Channel (kernel_2_3_G):');
%     disp(kernel_2_3_G);
%     disp('Kernel 2-3 for Blue Channel (kernel_2_3_B):');
%     disp(kernel_2_3_B);
%     
    %% Define down road biases
    % biases
    biases_down_R = single(-0.03963998);
    biases_down_G = single(-0.04988913);
    biases_down_B = single(-0.06924444);
    
    % 將bias轉換成為定點數
    biases_down_R = floatToFixedPoint(biases_down_R, fractionLength);
    biases_down_G = floatToFixedPoint(biases_down_G, fractionLength);
    biases_down_B = floatToFixedPoint(biases_down_B, fractionLength);
%     % 顯示bias數值
%     disp('biases_up_R:');
%     disp(biases_up_R);
%     
%     disp('biases_up_G:');
%     disp(biases_up_G);
%     
%     disp('biases_up_B:');
%     disp(biases_up_B);
     
    %% operation here
                %% 合併Kernel
    Big_Kernel_uproad_R = kernel_1_1_R + kernel_1_2_R + kernel_1_3_R;
    Big_Kernel_uproad_G = kernel_1_1_G + kernel_1_2_G + kernel_1_3_G;
    Big_Kernel_uproad_B = kernel_1_1_B + kernel_1_2_B + kernel_1_3_B;

    Big_Kernel_downroad_R = kernel_2_1_R + kernel_2_2_R + kernel_2_3_R;
    Big_Kernel_downroad_G = kernel_2_1_G + kernel_2_2_G + kernel_2_3_G;
    Big_Kernel_downroad_B = kernel_2_1_B + kernel_2_2_B + kernel_2_3_B;
    
%     % 显示结果
%     disp('Big Kernel Uproad for Red Channel:');
%     disp(Big_Kernel_uproad_R);
%     
%     disp('Big Kernel Uproad for Green Channel:');
%     disp(Big_Kernel_uproad_G);
%     
%     disp('Big Kernel Uproad for Blue Channel:');
%     disp(Big_Kernel_uproad_B);
%     
%     disp('Big Kernel Downroad for Red Channel:');
%     disp(Big_Kernel_downroad_R);
%     
%     disp('Big Kernel Down for Green Channel:');
%     disp(Big_Kernel_downroad_G);
%     
%     disp('Big Kernel Down for Blue Channel:');
%     disp(Big_Kernel_downroad_B);

    %% UP road operation here
    % UP road conv
    output_up_conv_R = custom_conv2(input_cell_R,Big_Kernel_uproad_R);
    output_up_conv_G = custom_conv2(input_cell_G,Big_Kernel_uproad_G);
    output_up_conv_B = custom_conv2(input_cell_B,Big_Kernel_uproad_B);
    
%     % Result of uproad conv Display here
%     disp('output_up_conv_R');
%     disp(output_up_conv_R);
%     disp('output_up_conv_G');
%     disp(output_up_conv_G);
%     disp('output_up_conv_B');
%     disp(output_up_conv_B);

    % Up road bias
    output_up_bias_R = output_up_conv_R + biases_up_R;
    output_up_bias_G = output_up_conv_G + biases_up_G;
    output_up_bias_B = output_up_conv_B + biases_up_B;

%     % Result of bias display here
%     disp('output_up_bias_R');
%     disp(output_up_bias_R);
%     disp('output_up_bias_G');
%     disp(output_up_bias_G);
%     disp('output_up_bias_B');
%     disp(output_up_bias_B);

    % Up road relu
    output_up_relu_R = relu(output_up_bias_R);
    output_up_relu_G = relu(output_up_bias_G);
    output_up_relu_B = relu(output_up_bias_B);

%     % Display up road output relu R,G,B here
%     disp('output_up_relu_R');
%     disp(output_up_relu_R);
%     disp('output_up_relu_G');
%     disp(output_up_relu_G);
%     disp('output_up_relu_B');
%     disp(output_up_relu_B);
    
    % output uproad here;
    output_uproad_R = output_up_relu_R + medium_pxl_origin_R;
    output_uproad_G = output_up_relu_G + medium_pxl_origin_G;
    output_uproad_B = output_up_relu_B + medium_pxl_origin_B;
    
%     % display uproad here;
%     disp('Output Uproad R:');
%     disp(output_uproad_R);
%     
%     disp('Output Uproad G:');
%     disp(output_uproad_G);
%     
%     disp('Output Uproad B:');
%     disp(output_uproad_B);

    %% Down road operation here
    % Down road conv
    output_down_conv_R = custom_conv2(input_cell_R,Big_Kernel_downroad_R);
    output_down_conv_G = custom_conv2(input_cell_G,Big_Kernel_downroad_G);
    output_down_conv_B = custom_conv2(input_cell_B,Big_Kernel_downroad_B);

%     % Result of downroad conv Display here
%     disp('output_down_conv_R');
%     disp(output_down_conv_R);
%     disp('output_down_conv_G');
%     disp(output_down_conv_G);
%     disp('output_down_conv_B');
%     disp(output_down_conv_B);

    % Down road bias
    output_down_bias_R = output_down_conv_R + biases_down_R;
    output_down_bias_G = output_down_conv_G + biases_down_G;
    output_down_bias_B = output_down_conv_B + biases_down_B;

%     % Result of bias display here
%     disp('output_down_bias_R');
%      disp(output_down_bias_R);
%     disp('output_down_bias_G');
%      disp(output_down_bias_G);
%     disp('output_down_bias_B');
%      disp(output_down_bias_B);

    % Down road relu
    output_down_relu_R = relu(output_down_bias_R);
    output_down_relu_G = relu(output_down_bias_G);
    output_down_relu_B = relu(output_down_bias_B);

%     % Display down road output relu R,G,B here
%     disp('output_down_relu_R');
%      disp(output_down_relu_R);
%     disp('output_down_relu_G');
%      disp(output_down_relu_G);
%     disp('output_down_relu_B');
%      disp(output_down_relu_B);

    % output down here;
    output_downroad_R = output_down_relu_R + medium_pxl_origin_R;
    output_downroad_G = output_down_relu_G + medium_pxl_origin_G;
    output_downroad_B = output_down_relu_B + medium_pxl_origin_B;

%     % display uproad here;
%     disp('Output downroad R:');
%      disp(output_downroad_R);
%     
%     disp('Output downroad G:');
%      disp(output_downroad_G);
%     
%     disp('Output downroad B:');
%      disp(output_downroad_B);

    %% Final output 1pxl here
    output_onepxl_R = output_uproad_R + output_downroad_R;
    output_onepxl_G = output_uproad_G + output_downroad_G;
    output_onepxl_B = output_uproad_B + output_downroad_B;

%     % 显示结果
%     disp('Output One Pixel R:');
%     disp(output_onepxl_R);
%     
%     disp('Output One Pixel G:');
%     disp(output_onepxl_G);
%     
%     disp('Output One Pixel B:');
%     disp(output_onepxl_B);
    
    % 將所有輸出定點
    output_onepxl_R = floatToFixedPoint(output_onepxl_R, fractionLength);
    output_onepxl_G = floatToFixedPoint(output_onepxl_G, fractionLength);
    output_onepxl_B = floatToFixedPoint(output_onepxl_B, fractionLength);
    
    % 确保所有输入都是 single 类型
    output_onepxl_R = single(output_onepxl_R);
    output_onepxl_G = single(output_onepxl_G);
    output_onepxl_B = single(output_onepxl_B);
    
    % 将 RGB 三个通道乘以 16 并限定最大值不超过 16
    output_onepxl_R_scaled = min(output_onepxl_R * 16, 16);
    output_onepxl_G_scaled = min(output_onepxl_G * 16, 16);
    output_onepxl_B_scaled = min(output_onepxl_B * 16, 16);
    
    % 将 RGB 三个通道合并
    output_onepxl_combined = cat(3, output_onepxl_R_scaled, output_onepxl_G_scaled, output_onepxl_B_scaled);
    %     % 顯示結果
    %     disp('output_onepxl_combined')
    %     disp(output_onepxl_combined)


end