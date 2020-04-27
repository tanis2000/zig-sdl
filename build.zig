const std = @import("std");
const builtin = @import("builtin");
const Builder = std.build.Builder;
const path = std.fs.path;

pub fn build(b: *Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib_cflags = &[_][]const u8{"-std=c99"};

    const sdl = b.addStaticLibrary("SDL2", null);
    sdl.setBuildMode(mode);
    sdl.setTarget(target);
    sdl.linkSystemLibrary("c");
    sdl.addIncludeDir("deps/sdl/include");
    for (sdl_generic_src_files) |src_file| {
        const full_src_path = path.join(b.allocator, &[_][]const u8{ "deps", "sdl", src_file }) catch unreachable;
        sdl.addCSourceFile(full_src_path, lib_cflags);
    }
    if (builtin.os.tag == .macosx) {
        sdl.addIncludeDir("deps/sdl/src/hidapi");
        sdl.addIncludeDir("deps/sdl/src/hidapi/hidapi");
        for (sdl_macos_src_files) |src_file| {
            const full_src_path = path.join(b.allocator, &[_][]const u8{ "deps", "sdl", src_file }) catch unreachable;
            sdl.addCSourceFile(full_src_path, lib_cflags);
        }
        sdl.addFrameworkDir("/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks");
        sdl.addSystemIncludeDir("/usr/local/include");
        sdl.addSystemIncludeDir("/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.3/include");
        sdl.addSystemIncludeDir("/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include");
        sdl.addSystemIncludeDir("/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include");
        
        sdl.linkFramework("AppKit");
        sdl.linkFramework("AudioToolbox");
        sdl.linkFramework("AudioUnit"); 
        sdl.linkFramework("Carbon");
        sdl.linkFramework("Cocoa");
        sdl.linkFramework("CoreAudio");
        sdl.linkFramework("CoreFoundation");
        sdl.linkFramework("CoreServices");
        sdl.linkFramework("CoreVideo");
        sdl.linkFramework("ForceFeedback");
        sdl.linkFramework("IOKit");
        sdl.linkFramework("OpenGL");
        sdl.linkFramework("Security");

        sdl.defineCMacro("TARGET_API_MAC_CARBON");
        sdl.defineCMacro("TARGET_API_MAC_OSX");
        sdl.defineCMacro("_THREAD_SAFE");
        sdl.defineCMacro("__APPLE__");
        sdl.defineCMacro("__MACOSX__");
    }
    sdl.install();

    const exe = b.addExecutable("test-zig-binocle", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.linkLibrary(sdl);
    exe.addIncludeDir("deps/sdl/include");
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);


}

const sdl_generic_src_files = [_][]const u8{
    "src/SDL.c",
    "src/SDL_assert.c",
    "src/SDL_dataqueue.c",
    "src/SDL_error.c",
    "src/SDL_hints.c",
    "src/SDL_log.c",
    "src/atomic/SDL_atomic.c",
    "src/atomic/SDL_spinlock.c",
    "src/audio/SDL_audio.c",
    "src/audio/SDL_audiocvt.c",
    "src/audio/SDL_audiotypecvt.c",
    "src/audio/SDL_mixer.c",
    "src/audio/SDL_wave.c",
    "src/cpuinfo/SDL_cpuinfo.c",
    //"src/cpuinfo/SDL_simd.c",
    "src/dynapi/SDL_dynapi.c",
    "src/events/SDL_clipboardevents.c",
    "src/events/SDL_displayevents.c",
    "src/events/SDL_dropevents.c",
    "src/events/SDL_events.c",
    "src/events/SDL_gesture.c",
    "src/events/SDL_keyboard.c",
    "src/events/SDL_mouse.c",
    "src/events/SDL_quit.c",
    "src/events/SDL_touch.c",
    "src/events/SDL_windowevents.c",
    "src/file/SDL_rwops.c",
    "src/haptic/SDL_haptic.c",
    "src/joystick/SDL_gamecontroller.c",
    "src/joystick/SDL_joystick.c",
    "src/joystick/hidapi/SDL_hidapijoystick.c",
    "src/joystick/hidapi/SDL_hidapi_ps4.c",
    "src/joystick/hidapi/SDL_hidapi_switch.c",
    "src/joystick/hidapi/SDL_hidapi_xbox360.c",
    "src/joystick/hidapi/SDL_hidapi_xboxone.c",
    "src/joystick/steam/SDL_steamcontroller.c",
    "src/libm/e_atan2.c",
    "src/libm/e_exp.c",
    "src/libm/e_fmod.c",
    "src/libm/e_log.c",
    "src/libm/e_log10.c",
    "src/libm/e_pow.c",
    "src/libm/e_rem_pio2.c",
    "src/libm/e_sqrt.c",
    "src/libm/k_cos.c",
    "src/libm/k_rem_pio2.c",
    "src/libm/k_sin.c",
    "src/libm/k_tan.c",
    "src/libm/s_atan.c",
    "src/libm/s_copysign.c",
    "src/libm/s_cos.c",
    "src/libm/s_tan.c",
    "src/libm/s_fabs.c",
    "src/libm/s_floor.c",
    "src/libm/s_scalbn.c",
    "src/libm/s_sin.c",
    "src/power/SDL_power.c",
    "src/render/SDL_render.c",
    "src/render/SDL_yuv_sw.c",
    "src/sensor/SDL_sensor.c",
    "src/sensor/dummy/SDL_dummysensor.c",
    "src/stdlib/SDL_getenv.c",
    "src/stdlib/SDL_iconv.c",
    "src/stdlib/SDL_malloc.c",
    "src/stdlib/SDL_qsort.c",
    "src/stdlib/SDL_stdlib.c",
    "src/stdlib/SDL_string.c",
    "src/thread/SDL_thread.c",
    "src/timer/SDL_timer.c",
    "src/video/SDL_RLEaccel.c",
    "src/video/SDL_blit.c",
    "src/video/SDL_blit_0.c",
    "src/video/SDL_blit_1.c",
    "src/video/SDL_blit_A.c",
    "src/video/SDL_blit_N.c",
    "src/video/SDL_blit_auto.c",
    "src/video/SDL_blit_copy.c",
    "src/video/SDL_blit_slow.c",
    "src/video/SDL_bmp.c",
    "src/video/SDL_clipboard.c",
    "src/video/SDL_fillrect.c",
    "src/video/SDL_pixels.c",
    "src/video/SDL_rect.c",
    "src/video/SDL_shape.c",
    "src/video/SDL_stretch.c",
    "src/video/SDL_surface.c",
    "src/video/SDL_video.c",
    "src/video/SDL_vulkan_utils.c",
    "src/video/SDL_yuv.c",
    "src/video/yuv2rgb/yuv_rgb.c",
    "src/audio/disk/SDL_diskaudio.c",
    "src/loadso/dlopen/SDL_sysloadso.c",
    "src/render/opengl/SDL_render_gl.c",
    "src/render/opengl/SDL_shaders_gl.c",
    "src/render/software/SDL_blendfillrect.c",
    "src/render/software/SDL_blendline.c",
    "src/render/software/SDL_blendpoint.c",
    "src/render/software/SDL_drawline.c",
    "src/render/software/SDL_drawpoint.c",
    "src/render/software/SDL_render_sw.c",
    "src/render/software/SDL_rotate.c",
    "src/video/dummy/SDL_nullevents.c",
    "src/video/dummy/SDL_nullframebuffer.c",
    "src/video/dummy/SDL_nullvideo.c",
    "src/audio/dummy/SDL_dummyaudio.c",
};

const sdl_macos_src_files = [_][]const u8 {
    "src/sensor/coremotion/SDL_coremotionsensor.m",
    "src/hidapi/mac/hid.c",
    "src/thread/pthread/SDL_syscond.c",
    "src/thread/pthread/SDL_sysmutex.c",
    "src/thread/pthread/SDL_syssem.c",
    "src/thread/pthread/SDL_systhread.c",
    "src/thread/pthread/SDL_systls.c",
    "src/timer/unix/SDL_systimer.c",
    "src/audio/coreaudio/SDL_coreaudio.m",
    "src/joystick/darwin/SDL_sysjoystick.c",
    "src/haptic/darwin/SDL_syshaptic.c",
    "src/power/macosx/SDL_syspower.c",
    "src/file/cocoa/SDL_rwopsbundlesupport.m",
    "src/filesystem/cocoa/SDL_sysfilesystem.m",
    "src/video/SDL_egl.c",
    "src/video/cocoa/SDL_cocoaclipboard.m",
    "src/video/cocoa/SDL_cocoaevents.m",
    "src/video/cocoa/SDL_cocoakeyboard.m",
    "src/video/cocoa/SDL_cocoamessagebox.m",
    "src/video/cocoa/SDL_cocoamodes.m",
    "src/video/cocoa/SDL_cocoamouse.m",
    "src/video/cocoa/SDL_cocoamousetap.m",
    "src/video/cocoa/SDL_cocoaopengl.m",
    "src/video/cocoa/SDL_cocoashape.m",
    "src/video/cocoa/SDL_cocoavideo.m",
    "src/video/cocoa/SDL_cocoavulkan.m",
    "src/video/cocoa/SDL_cocoawindow.m",
};