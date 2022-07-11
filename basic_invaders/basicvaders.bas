$Debug
' Invader Type
Type InvaderType
    x As Integer
    y As Integer
    Right As Integer
    Speed As Integer
    Drop As Integer
    Spacing As Integer
    Pic As Long
    Height As Integer
    Width As Integer
    killed As Integer
End Type

' Shooter Type
Type ShooterType
    X As Integer
    Y As Integer
    Speed As Integer
    Pic As Long
    Height As Integer
    Width As Integer
End Type

' Shot Type
Type ShotType
    X As Integer
    Y As Integer
    Speed As Integer
    Pic As Long
    Height As Integer
    Width As Integer
    Fired As Integer
End Type

' Window Height and Width
Type WindowType
    Height As Integer
    Width As Integer
End Type

' Constants
Const NumInvaders = 10

' Globals
Dim Shared Invaders(NumInvaders) As InvaderType
Dim Shared Shooter As ShooterType
Dim Shared shot As ShotType
Dim Shared w As WindowType
' Music and Sounds Effects
Dim Shared DeadSound As Long
Dim Shared HitSound As Long
Dim Shared IntroSound As Long
Dim Shared ShotSound As Long
Dim Shared WinSound As Long
' Win or Lose Game
Dim Shared Lose As Integer
Dim Shared Win As Integer
' Shot Down
Dim Shared ShotDown As Integer
' Play Again?
Dim Shared Again As String

' Game Window
w.Width = 800
w.Height = 600

' Set Window Height and Width Use 32-bit Colors
Screen _NewImage(w.Width, w.Height, 32)

' Call LoadSettings Sub
LoadSettings

' Loop until q key is pushed
Do
    _Limit 100
    PCopy _Display, 1
    ' Call MoveShooter Sub
    MoveShooter
    FireShot
    _Display
    PCopy 1, _Display

Loop Until InKey$ = "q"


'LoadSettings Sub
Sub LoadSettings
    Lose = 0
    Win = 0
    ShotDown = 0
    Shooter.Pic = _LoadImage("basic_invaders\shooter.png")
    Shooter.Speed = 6
    Shooter.Height = 50
    Shooter.Width = 50
    Shooter.X = (w.Width / 2) - (Shooter.Width / 2) - 1
    Shooter.Y = w.Height - Shooter.Height - 1

    ' Shot Settings
    shot.Pic = _LoadImage("basic_invaders\shot.png")
    shot.Speed = 9
    shot.Height = 20
    shot.Width = 10

    ' Load Sfx and Music
    DeadSound = _SndOpen("basic_invaders\dead.wav", "sync,vol")
    HitSound = _SndOpen("basic_invaders\hit.wav", "sync,vol")
    IntroSound = _SndOpen("basic_invaders\intro.wav", "sync,vol")
    ShotSound = _SndOpen("basic_invaders\shot.wav", "sync,vol")
    WinSound = _SndOpen("basic_invaders\win.wav", "sync,vol")

End Sub


' Move Shooter Sub
Sub MoveShooter
    If _KeyDown(CVI(Chr$(0) + "K")) And Shooter.X >= 0 Then
        Shooter.X = Shooter.X - Shooter.Speed
    End If
    If _KeyDown(CVI(Chr$(0) + "M")) And Shooter.X + Shooter.Width <= w.Width - 30 Then
        Shooter.X = Shooter.X + Shooter.Speed
    End If
    _PutImage (Shooter.X, Shooter.Y), Shooter.Pic
End Sub

' Fire Shot Sub
Sub FireShot
    If _KeyDown(32) And shot.Fired = 0 Then
        _SndPlayCopy ShotSound
        shot.Fired = 1
        shot.X = Shooter.X + (Shooter.Width / 2) - (shot.Width / 2)
    End If
    If shot.Fired = 1 Then
        shot.Y = shot.Y - shot.Speed
        _PutImage (shot.X, shot.Y), shot.Pic
    End If
    If shot.Fired = 0 Then
        shot.Y = -30
    End If
    If shot.Y + shot.Height <= 0 Then
        shot.Fired = 0
    End If
End Sub
