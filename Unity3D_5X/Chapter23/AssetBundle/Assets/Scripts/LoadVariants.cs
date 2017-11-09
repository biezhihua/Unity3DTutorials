using UnityEngine;
using System.Collections;

/// <summary>
/// 加载Variant
/// </summary>
public class LoadVariants : MonoBehaviour {
	//场景文件名称
	public string sceneAssetBundle = "variants/variant-scene";
	//场景名称
	public string sceneName = "variantScene";
	public string[] activeVariants = {"hd"};

	// Use this for initialization
	IEnumerator Start()
	{
		//场景AssetBundle路径
		string path = "file://" + Application.dataPath + "/AssetBundles/" + sceneAssetBundle+"."+activeVariants[0];

		WWW www = WWW.LoadFromCacheOrDownload(path, 0);
		yield return www;
		if (www.error == null)
		{
			AssetBundle ab = www.assetBundle;
			AsyncOperation async = Application.LoadLevelAsync(sceneName);
			yield return async;
		}
		else
		{
			Debug.Log(www.error);
		}
		

	}

	private void Update()
	{
		if (Input.GetKeyDown(KeyCode.A))
		{
			Application.LoadLevel(0);
		}
	}

}
