using UnityEngine;
using System.Collections;

/// <summary>
/// 加载无依赖资源的AssetBundle
/// </summary>
public class LoadNoDependenciesAssets : MonoBehaviour
{
	
	public string assetBundleName;
	public string assetName;
	
	// Use this for initialization
	IEnumerator Start ()
	{
		string path = "file://" + Application.dataPath + "/AssetBundles/" + assetBundleName;
		
		WWW www = WWW.LoadFromCacheOrDownload(path, 0);
		yield return www;
		if (www.error == null)
		{
			AssetBundle ab = www.assetBundle;
			GameObject g = ab.LoadAsset(assetName) as GameObject;
			if (g != null)
			{
				Instantiate(g);
				ab.Unload(false);
			}
			else
			{
				Debug.Log("g==null");
			}
		}
		else
		{
			Debug.Log(www.error);
		}

		
	}

	
	
}
