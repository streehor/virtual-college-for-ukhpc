shader_type spatial;
render_mode unshaded, blend_mix, cull_disabled;

// Your background image. 'repeat_enable' is required so it tiles endlessly.
uniform sampler2D background_texture : source_color, filter_nearest, repeat_enable;

// The scale of the parallax effect. 
// A value of 0.0 means it stays completely still (infinitely far).
// A value of 1.0 means it moves exactly with the camera (flat against the screen).
uniform vec2 parallax_scale = vec2(0.1, 0.1); 

// The incoming camera coordinates. 
// If your camera moves on the X and Z axes, pass those two values into this vec2.
uniform vec2 camera_position_2d = vec2(0.0, 0.0);

void fragment() {
    // Offset the plane's UV coordinates by the camera's position, scaled by depth
    vec2 parallax_uv = UV + (camera_position_2d * parallax_scale);
    
    // Sample the texture using the new shifted UVs
    vec4 tex_color = texture(background_texture, parallax_uv);
    
    // Output final color and transparency
    ALBEDO = tex_color.rgb;
    ALPHA = tex_color.a; 
}