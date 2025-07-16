


local a=game:GetService("Players")
local b=game:GetService("RunService")
local c=game:GetService("Workspace")
local d=game:GetService("Lighting")

d.Brightness=1
d.Ambient=Color3.fromRGB(128,128,128)
d.OutdoorAmbient=Color3.fromRGB(128,128,128)
d.FogEnd=1000

for e,f in pairs(d:GetChildren()) do
    if f:IsA("PostEffect") then f:Destroy() end
end

local g=game:GetService("CoreGui")
local h=game:GetService("TeleportService")
local i=game:GetService("ReplicatedStorage")
local j=a.LocalPlayer
local k=c.CurrentCamera

local function l()
    h:Teleport(game.PlaceId,j)
end

g.ChildAdded:Connect(function(m)
    if m:IsA("ScreenGui") and m.Name=="ErrorPrompt" then
        task.wait(2)
        l()
    end
end)

local n,o=pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not n or not o then
    warn("zeckhub failed")
    return
end

local p=o:CreateWindow({
    Name="zeckhub",
    LoadingTitle="loading ZeckHub...",
    LoadingSubtitle="by Robertzeck",
    ConfigurationSaving={
        Enabled=true,
        FileName="zeckhub_config"
    },
    KeySystem=false,
    KeySettings={
        Title="Access Required",
        Subtitle="Enter the key to continue",
        Note="Join Discord for key",
        FileName="zeckhub_key",
        SaveKey=true,
        GrabKeyFromSite=false,
        Key="robertzeck08"
    },
    Theme="Dark",
    ToggleUIKeybind=Enum.KeyCode.K
})

local q=p:CreateTab("Updates","bell-dot")
local r=q:CreateSection("change longs")
local s=q:CreateParagraph({
    Title="Updates",
    Content="Added a toggle for the hitbox, character esp to know where you aim with the auto shift locks. Small textual guides were also added, nothing important."
})
local s=q:CreateParagraph({
    Title="Updates soon",
    Content="The directional hit will be coming soon. For now, we have brought you the esp character. We will be working on the directional hit and the powerful serve."
})

local t=p:CreateTab("Game","flame")
local r=t:CreateSection("Hitbox ball")
local u=10.0
local v=true

local function w(x)
    for e,y in ipairs(x:GetDescendants()) do
        if y:IsA("BasePart") then return y end
    end
end

local function z(A)
    for e,x in ipairs(c:GetChildren()) do
        if x:IsA("Model") and x.Name:match("^CLIENT_BALL_%d+$") then
            local B=x:FindFirstChild("Ball.001")
            if not B then
                local C=w(x)
                if C then
                    B=Instance.new("Part")
                    B.Name="Ball.001"
                    B.Shape=Enum.PartType.Ball
                    B.Size=Vector3.new(2,2,2)*A
                    B.CFrame=C.CFrame
                    B.Anchored=true
                    B.CanCollide=false
                    B.Transparency=0.7
                    B.Material=Enum.Material.ForceField
                    B.Color=Color3.fromRGB(0,255,0)
                    B.Parent=x
                end
            else
                B.Size=Vector3.new(2,2,2)*A
            end
        end
    end
end

local function D()
    for e,x in ipairs(c:GetChildren()) do
        if x:IsA("Model") and x.Name:match("^CLIENT_BALL_%d+$") then
            local B=x:FindFirstChild("Ball.001")
            if B then B:Destroy() end
        end
    end
end

workspace.ChildAdded:Connect(function(m)
    if m:IsA("Model") and m.Name:match("^CLIENT_BALL_%d+$") then
        task.wait(0.1)
        if v then z(u) end
    end
end)

t:CreateSlider({
    Name="Hitbox Size",
    Range={0,20},
    Increment=0.1,
    Suffix="x",
    CurrentValue=u,
    Callback=function(E)
        u=E
        z(E)
        o:Notify({
            Title="Size Changed",
            Content="Hitbox scale set to "..E.."x",
            Duration=2,
            Image="maximize"
        })
    end
})

t:CreateToggle({
    Name="Enable Hitboxes",
    CurrentValue=true,
    Callback=function(E)
        v=E
        if E then
            z(u)
            o:Notify({
                Title="Hitboxes Enabled",
                Content="Ball hitboxes created",
                Duration=2,
                Image="check"
            })
        else
            D()
            o:Notify({
                Title="Hitboxes Disabled",
                Content="Ball hitboxes removed",
                Duration=2,
                Image="x"
            })
        end
    end
})

local F=p:CreateTab("maim","user-round")
local r=F:CreateSection("character funtions")
local G=true
local H=false
local I=16
local J=nil
local K=true

local function L()
    local M=j.Character and j.Character:FindFirstChild("Humanoid")
    return M and M.WalkSpeed or 16
end

local function N(O)
    if J then return end
    local P=Instance.new("BodyVelocity")
    P.MaxForce=Vector3.new(1e5,0,1e5)
    P.Velocity=Vector3.zero
    P.P=2500
    P.Name="AirControlVelocity"
    P.Parent=O
    J=P
end

local function Q()
    if J then
        J:Destroy()
        J=nil
    end
end

local function R(S)
    local M=S:WaitForChild("Humanoid")
    local O=S:WaitForChild("HumanoidRootPart")
    I=L()
    M:GetPropertyChangedSignal("Jump"):Connect(function()
        if M.Jump then
            if assistAimbotEnabled then
                local T=getClosestEnemy()
                if T and T.Character then
                    local U=T.Character:FindFirstChild("HumanoidRootPart")
                    if U then
                        O.CFrame=CFrame.new(O.Position,Vector3.new(U.Position.X,O.Position.Y,U.Position.Z))
                        M.AutoRotate=false
                        return
                    end
                end
            end
            if G then
                task.defer(function()
                    task.wait(0.03)
                    local V=Vector3.new(k.CFrame.LookVector.X,0,k.CFrame.LookVector.Z)
                    if V.Magnitude>0 then
                        O.CFrame=CFrame.lookAt(O.Position,O.Position+V.Unit)
                        M.AutoRotate=false
                    end
                end)
            else
                M.AutoRotate=true
            end
        end
    end)
    M.StateChanged:Connect(function(e,W)
        if W==Enum.HumanoidStateType.Freefall then
            if H then N(O) end
        elseif W==Enum.HumanoidStateType.Landed then
            Q()
            M.AutoRotate=true
        end
    end)
end

if j.Character then R(j.Character) end
j.CharacterAdded:Connect(R)

F:CreateToggle({
    Name="Auto Shift Lock",
    CurrentValue=true,
    Callback=function(E) G=E end
})

F:CreateToggle({
    Name="Air Movement (Freeflight)",
    CurrentValue=false,
    Callback=function(E)
        H=E
        if not E then Q() end
    end
})

F:CreateSlider({
    Name="Air Movement Speed",
    Range={0,100},
    Increment=1,
    CurrentValue=L(),
    Suffix=" studs/s",
    Callback=function(E) I=E end
})

b.RenderStepped:Connect(function()
    if H and J and j.Character then
        local M=j.Character:FindFirstChild("Humanoid")
        if M then
            J.Velocity=M.MoveDirection*I
        end
    end
end)

local X={}
X.enabled=false
X.color=Color3.fromRGB(255,255,255)
X.espFolder=nil
X.clones={}
X.renderConnection=nil

local a=game:GetService("Players")
local b=game:GetService("RunService")
local c=game:GetService("Workspace")
local k=c.CurrentCamera
local Y=a.LocalPlayer

local Z={
    Head=true,Torso=true,UpperTorso=true,LowerTorso=true,
    LeftArm=true,RightArm=true,LeftUpperArm=true,RightUpperArm=true,
    LeftLowerArm=true,RightLowerArm=true,LeftHand=true,RightHand=true,
    LeftLeg=true,RightLeg=true,LeftUpperLeg=true,RightUpperLeg=true,
    LeftLowerLeg=true,RightLowerLeg=true,LeftFoot=true,RightFoot=true,
    HumanoidRootPart=true
}

local _=5
local a0=0.3

function X:Cleanup()
    if self.renderConnection then
        self.renderConnection:Disconnect()
        self.renderConnection=nil
    end
    if self.espFolder then
        self.espFolder:Destroy()
        self.espFolder=nil
    end
    self.clones={}
end

function X:CopyVisualProperties(a1,a2)
    a2.Material=a1.Material
    a2.Transparency=a1.Transparency+a0
    a2.Color=self.color
    for e,m in ipairs(a1:GetChildren()) do
        if m:IsA("Decal") or m:IsA("Texture") or m:IsA("SurfaceGui") then
            m:Clone().Parent=a2
        end
    end
end

function X:CreateESP(S)
    if not S then return end
    local O=S:FindFirstChild("HumanoidRootPart")
    if not O then return end
    self:Cleanup()
    self.espFolder=Instance.new("Folder")
    self.espFolder.Name="ESP_Clones"
    self.espFolder.Parent=k
    for e,y in ipairs(S:GetChildren()) do
        if (y:IsA("Part") or y:IsA("MeshPart")) and Z[y.Name] then
            local a2=y:Clone()
            a2.Anchored=true
            a2.CanCollide=false
            a2.CanTouch=false
            a2.CanQuery=false
            a2.Parent=self.espFolder
            self:CopyVisualProperties(y,a2)
            for e,m in ipairs(a2:GetChildren()) do
                if m:IsA("Script") or m:IsA("LocalScript") or m:IsA("ModuleScript") or m:IsA("Motor6D") or m:IsA("Weld") or m:IsA("WeldConstraint") or m:IsA("Humanoid") or m:IsA("Attachment") then
                    m:Destroy()
                end
            end
            self.clones[y]=a2
        end
    end
    self.renderConnection=b.RenderStepped:Connect(function()
        if not S or not S.Parent or not O then return end
        local a3=k.CFrame.LookVector
        local a4=Vector3.new(a3.X,0,a3.Z)
        if a4.Magnitude>0 then
            a4=a4.Unit
        else
            a4=Vector3.new(0,0,1)
        end
        local a5=O.Position-a4*_
        local a6=CFrame.new(a5,a5+a4)
        for a7,a2 in pairs(self.clones) do
            if a7 and a7:Is
```
