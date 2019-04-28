# Homework1C

This part of the homework implements a cellular automata by using a rendertexture with a ping pong implementation. In the script I randomly spawn black and white 
sqaures in a 64x64 square surface. Then in the shader, RenderToTexture, I have some
simple rules for a pixel. If there is more of another color surrounding itself then 
become the other color. However, if there is exactly one of another color then 
become the other color. Otherwise, just stay the same color. These simple rules
cause a flow of black and white squares to constantly shift. 