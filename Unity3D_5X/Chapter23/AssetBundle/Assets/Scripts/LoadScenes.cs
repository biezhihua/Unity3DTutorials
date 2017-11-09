using UnityEngine;
using System.Collections;


/// <summary>
/// 加载Scene
/// </summary>
public class LoadScenes : MonoBehaviour {
    //场景文件名称
    public string sceneAssetBundle;
    //场景名称
    public string sceneName;

    // Use this for initialization
    IEnumerator Start()
    {
        //场景AssetBundle路径
        string path = "file://" + Application.dataPath + "/AssetBundles/" + sceneAssetBundle;
       
        WWW www = WWW.LoadFromCacheOrDownload(path, 0);
        yield return www;
        if (www.error == null)
        {
           
            AsyncOperation async = Application.LoadLevelAsync(sceneName);
            yield return async;
        }
        else
        {
            Debug.Log(www.error);
        }


    }
}
