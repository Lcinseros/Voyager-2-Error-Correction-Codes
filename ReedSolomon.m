% This is an implementation of an RS()

% Loads the image and stores its dimensions
image = uint8(imread('earth.png'));
imageDim = size(image);

n = 255;
k = 223;
primitivePolynomial = 285; % 285 = 0b100011101 -> X^8 + X^4 + X^3 + X^2 + 1
m = 8;

intStream = reshape(image, [], 1);

% The encoder function requires 
numInts = imageDim(1) * imageDim(2) * imageDim(3);
numMsgs = (uint32(numInts / k));
paddedLength = k * numMsgs;

intStream(paddedLength) = 0;
messages = reshape(intStream, k, []);
decodedMessages = zeros(size(messages));

gp = rsgenpoly(n, k, primitivePolynomial);

rsEncoder = comm.RSEncoder(n, k, gp);
rsDecoder = comm.RSDecoder(n, k, gp);

for msg = 1:numMsgs
    encodedMessages(:, msg) = rsEncoder(messages(:, msg));
end

for msg = 1:numMsgs
    decodedMessages(:, msg) = rsDecoder(encodedMessages(:, msg));
end

decodedMessages = decodedMessages(1:numInts);
decodedImage = uint8(reshape(decodedMessages(), imageDim(1), imageDim(2), []));

imshow(decodedImage);