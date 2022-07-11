$Debug

' Copyright 2022 Jeremy Stevens <jeremiahstevens@gmail.com>
'
' Permission is hereby granted, free of charge, to any person obtaining
' a copy of this software and associated documentation files (the
' "Software"), to deal in the Software without restriction, including
' without limitation the rights to use, copy, modify, merge, publish,
' distribute, sublicense, and/or sell copies of the Software, and to
' permit persons to whom the Software is furnished to do so, subject to
' the following conditions:
'
' The above copyright notice and this permission notice shall be
' included in all copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
' EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
' MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
' NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
' LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
' OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
' WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
' -----------------------------------------------------------------------------
' version = '0.0.1' - Beta
' -----------------------------------------------------------------------------

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
Dim Shared MovementSound As Long
' Win or Lose Game
Dim Shared Lose As Integer
Dim Shared Win As Integer
Dim Shared Level As Integer
Level = 1
' Shot Down
Dim Shared ShotDown As Integer
' Play Again?
Dim Shared Again As String

' Game Window Size
w.Width = 800
w.Height = 600
_Title "Basic Invaders" 'Set the window title

' Set Window Height and Width Use 32-bit Colors
Screen _NewImage(w.Width, w.Height, 32)
Do
    Cls
    ' Call LoadSettings Sub
    LoadSettings

    _SndPlay IntroSound

    ' Loop until q key is pushed
    Do
        _Limit 100
        PCopy _Display, 1
        ' Call MoveShooter Sub
        MoveShooter
        ' Call FireShot Sub
        FireShot
        'Check if Invader is Hit Sub
        CheckHit
        ' Call Move Invaders Sub
        MoveInvaders
        _Display
        PCopy 1, _Display
        ' Check if Game Over
        CheckGameOver
    Loop Until Win = 1 Or Lose = 1
Loop Until Again = "N"

'LoadSettings Sub
Sub LoadSettings
    Dim i As Integer
    Level = 0
    Lose = 0
    Win = 0
    ShotDown = 0
    Shooter.Pic = _LoadImage("basic_invaders\shooter.png")
    Shooter.Speed = 4
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
    ' (MovementSound) Not implemented
    MovementSound = _SndOpen("basic_invaders\movement.wav", "sync,vol")
    'Invader settings
    For i = 1 To NumInvaders
        Invaders(i).Right = 1
        Invaders(i).Pic = _LoadImage("basic_invaders\Invaders.png")
        Invaders(i).killed = 0
        Dim s As Integer
        If Level <= 1 Then
            s = 3
        End If
        If Level = 2 Then
            s = 6
        End If
        Invaders(i).Speed = s
        Invaders(i).Height = 50
        Invaders(i).Width = 50
        Invaders(i).Drop = 50
        Invaders(i).Spacing = 20
        Invaders(i).y = 0
        Invaders(i).x = -i * (Invaders(i).Width + Invaders(i).Spacing)
    Next
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
        shot.Y = Shooter.Y
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

' Move Invaders Sub
Sub MoveInvaders
    Dim i As Integer
    For i = 1 To NumInvaders
        ' Invaders Logic when invaders gets to end of screen drop down and move to the left or right.
        If Invaders(i).Right = 1 Then
            Invaders(i).x = Invaders(i).x + Invaders(i).Speed
        Else
            Invaders(i).x = Invaders(i).x - Invaders(i).Speed
        End If
        If Invaders(i).x + Invaders(i).Width >= w.Width = -1 And Invaders(i).Right = 1 Then
            Invaders(i).y = Invaders(i).y + Invaders(i).Drop
            Invaders(i).Right = 0
        End If
        If Invaders(i).x <= 0 And Invaders(i).Right = 0 Then
            Invaders(i).y = Invaders(i).y + Invaders(i).Drop
            Invaders(i).Right = 1
        End If
        If Invaders(i).killed = 0 Then
            _PutImage (Invaders(i).x, Invaders(i).y), Invaders(i).Pic
        End If
    Next
End Sub


' check if Invader has been hit sub
Sub CheckHit
    Dim i As Integer
    For i = 1 To NumInvaders
        If (shot.X + shot.Width >= Invaders(i).x) And (shot.X <= Invaders(i).x + Invaders(i).Width) And (shot.Y <= Invaders(i).y + Invaders(i).Height) And (shot.Y + shot.Height >= Invaders(i).y) And (Invaders(i).killed = 0) Then
            _SndPlayCopy HitSound
            Invaders(i).killed = 1
            ShotDown = ShotDown + 1
            shot.Fired = 0
        End If
    Next
End Sub

' Check Game Over Sub
Sub CheckGameOver
    Dim i As Integer
    For i = 1 To NumInvaders
        If Invaders(i).y + Invaders(i).Height >= Shooter.Y And Invaders(i).killed = 0 Then
            Lose = 1
            Level = 1
        End If
    Next
    If ShotDown = NumInvaders Then
        ' Increase Game Level
        If Level >= 9 Then
            Win = 1
        End If
    End If
End Sub

' Sub To increase Level of Difficulty
Sub IncreaseLevel
    Locate 20, 25
    Level = Level + 1
    Print "Next Level:", Level
    Sleep 3
End Sub

