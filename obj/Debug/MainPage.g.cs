﻿

#pragma checksum "C:\Users\jchee\Desktop\GraphicsProject\MainPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "2152432F1AED2BA0312E8640B07F6806"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Project
{
    partial class MainPage : global::Windows.UI.Xaml.Controls.SwapChainBackgroundPanel, global::Windows.UI.Xaml.Markup.IComponentConnector
    {
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
 
        public void Connect(int connectionId, object target)
        {
            switch(connectionId)
            {
            case 1:
                #line 15 "..\..\MainPage.xaml"
                ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(target)).Click += this.Jump;
                 #line default
                 #line hidden
                break;
            case 2:
                #line 16 "..\..\MainPage.xaml"
                ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(target)).Click += this.Shoot;
                 #line default
                 #line hidden
                break;
            }
            this._contentLoaded = true;
        }
    }
}


