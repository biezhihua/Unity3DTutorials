using UnityEngine;
using System.Collections;
using System.Collections.Generic;//使用List容器需要添加这个命名空间
public class CSharpArray2: MonoBehaviour {
	public List<int> list=new List<int>();//声明一个元素类型为int的List容器
	void Start () {
		for(int i=10;i>0;i--)
		{
			list.Add(i);//按10,9,8,,,1的顺序往list里面添加内容
		}
		list.Sort();//排序	
		foreach(int item in list ) Debug.Log(item);//打印list里的内容
	}
}
