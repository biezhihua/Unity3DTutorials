using UnityEngine;
using UnityEngine;
using UnityEditor;

public class MyWindow : EditorWindow {
	
	//在菜单栏Window下添加一个名为“New Window”的子菜单项
	[MenuItem("Window/New Window")]
	//创建窗口
	static void AddWindow()
	{
		MyWindow window = (MyWindow)EditorWindow.GetWindow (typeof(MyWindow), true, "New Window");
		window.Show ();
	}
	//选择贴图的对象
	private Texture texture;
	//输入文字的内容
	private string myString = "";
	//控制开关
	private bool myBool = true;
	//滑动条的值
	private float myFloat = 0.0f;
	//控制控件组
	private bool groupEnabled = true;
	
	//绘制窗口时调用
	void OnGUI ()
	{
		if (GUILayout.Button ("Open Text", GUILayout.Width (200))) {
			//打开一个通知栏
			this.ShowNotification (new GUIContent("This is a Notification"));
		}
		if (GUILayout.Button ("Close Text", GUILayout.Width (200))) {
			//关闭通知栏
			this.RemoveNotification ();
		}
		
		//选择贴图
		texture = EditorGUILayout.ObjectField ("Add Texture", texture, typeof(Texture), true) as Texture;		
		//显示文本
		GUILayout.Label ("Base Settings", EditorStyles.boldLabel);
		//绘制一个文本编辑框
		myString = EditorGUILayout.TextField ("Text Field", myString, GUILayout.Width (300));
		//绘制控件组，可以启用和禁用
		groupEnabled = EditorGUILayout.BeginToggleGroup ("ToggleGroup", groupEnabled);
		//开关
		myBool = EditorGUILayout.Toggle ("Toggle", myBool );
		//滑动条
		myFloat = EditorGUILayout.Slider ("Slider", myFloat, 0, 1);
		//结束控件组
		EditorGUILayout.EndToggleGroup ();
		if (GUILayout.Button ("Close Window", GUILayout.Width (200))) {
			//关闭窗口
			this.Close ();
		}
	}

}

