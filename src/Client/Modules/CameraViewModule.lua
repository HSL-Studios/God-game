-- Camera View Module
-- Username
-- July 20, 2020



local CameraViewModule = {}

local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local camera = workspace.CurrentCamera
local cameraOffset = Vector3.new(2, 2, 15)
local player = Players.localPlayer

player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid.AutoRotate = false

    local cameraAngleX = 0
    local cameraAngleY = 0

    local function playerInput(actionName, inputState, inputObject)
        if inputState == Enum.UserInputState.Change then 
            cameraAngleX = cameraAngleX - inputObject.Delta.X
            cameraAngleY = math.clamp(cameraAngleY - inputObject.Delta.Y*0.4, -75, 75)
            rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(-inpuitObject.Delta.X), 0)
        end
    end
    ContextActionService:BindAction("PlayerInput", playerInput, false, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch)
 
	RunService.RenderStepped:Connect(function()
		if camera.CameraType ~= Enum.CameraType.Scriptable then
			camera.CameraType = Enum.CameraType.Scriptable
		end
		local startCFrame = CFrame.new((rootPart.CFrame.Position)) * CFrame.Angles(0, math.rad(cameraAngleX), 0) * CFrame.Angles(math.rad(cameraAngleY), 0, 0)
		local cameraCFrame = startCFrame:ToWorldSpace(CFrame.new(cameraOffset.X, cameraOffset.Y, cameraOffset.Z))
		local cameraFocus = startCFrame:ToWorldSpace(CFrame.new(cameraOffset.X, cameraOffset.Y, -10000))
		camera.CFrame = CFrame.new(cameraCFrame.Position, cameraFocus.Position)
	end)
end)
 
local function focusControl(actionName, inputState, inputObject)
	-- Lock and hide mouse icon on input began
	if inputState == Enum.UserInputState.Begin then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
		ContextActionService:UnbindAction("FocusControl", focusControl, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.Focus)
	end
end
ContextActionService:BindAction("FocusControl", focusControl, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.Focus)

    

return CameraViewModule