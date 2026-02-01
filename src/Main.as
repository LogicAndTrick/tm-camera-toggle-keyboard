
/**
 * When a key is pressed, toggle between exactly two cameras.
 * Not all three cameras, which is what the default "Change camera" binding does.
 */
void OnKeyPress(bool down, VirtualKey key) {
    if (!isEnabled || !down || key != toggleKey) return;

    auto app = GetApp();
    if (app.CurrentPlayground is null) return;

    auto currentCamera = GetCameraStatus().AsChoice();
    if (currentCamera == cameraA) {
        SetCamChoice(cameraB);
    } else if (currentCamera == cameraB) {
        SetCamChoice(cameraA);
    }
}

// menu to toggle the plugin

const string MenuName = "\\$f82" + Icons::VideoCamera + "\\$z " + Meta::ExecutingPlugin().Name;

void RenderMenu() {
    if (UI::MenuItem(MenuName, "", isEnabled)) {
		isEnabled = !isEnabled;
	}
}

// settings

[Setting category="General" name="Enabled"]
bool isEnabled = true;

[Setting category="General" name="Toggle Key"]
VirtualKey toggleKey = VirtualKey::Space;

[Setting category="General" name="First camera"]
CamChoice cameraA = CamChoice::Cam1;

[Setting category="General" name="Second camera"]
CamChoice cameraB = CamChoice::Cam3;

enum CamChoice {
    Cam1, Cam1Alt,
    Cam2, Cam2Alt,
    Cam3, Cam3Alt,
    Cam7, Cam7Drivable,
    CamBackwards
}

// unused variables to maintain compatibility with XertroV's Camera.as script

bool S_PersistCameraBetweenMaps = false;
bool GameVersionSafe = false;
CamChoice lastSetCamChoice = CamChoice::Cam1;

// all below from: https://github.com/XertroV/tm-camera-toggle/blob/master/src/Main.as

CameraType GetCameraType(CamChoice cam) {
    if (cam == CamChoice::Cam1 || cam == CamChoice::Cam1Alt) return CameraType::Cam1;
    if (cam == CamChoice::Cam2 || cam == CamChoice::Cam2Alt) return CameraType::Cam2;
    if (cam == CamChoice::Cam3 || cam == CamChoice::Cam3Alt) return CameraType::Cam3;
    if (cam == CamChoice::Cam7 || cam == CamChoice::Cam7Drivable) return CameraType::FreeCam;
    if (cam == CamChoice::CamBackwards) return CameraType::Backwards;
    return CameraType::Cam1;
}

bool IsAltCam(CamChoice cam) {
    return cam == CamChoice::Cam1Alt || cam == CamChoice::Cam2Alt || cam == CamChoice::Cam3Alt;
}

bool IsDrivableCam(CamChoice cam) {
    return cam == CamChoice::Cam7Drivable;
}

void SetCamChoice(CamChoice cam) {
    lastSetCamChoice = cam;
    auto setTo = GetCameraType(cam);
    auto alt = IsAltCam(cam);
    auto drivable = IsDrivableCam(cam);
    auto app = GetApp();
    SetAltCamFlag(app, alt);
    SetDrivableCamFlag(app, drivable);
    SetCamType(app, setTo);
}