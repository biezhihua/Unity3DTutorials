using UnityEngine;
using System.Collections;
using System.IO;

public class LoadAssets : MonoBehaviour
{
    
    //总的manifest文件名称
    public string manifestName = "AssetBundles";
    //要加载的AssetBundle名称
    public string assetBundleName = "test";

    IEnumerator Start()
    {
        //assetbundle所在的路径
        string assetBundlePath = "file://" + Application.dataPath + "/AssetBundles/";
        //manifest文件所在路径
        string manifestPath = assetBundlePath + manifestName;

        //首先加载manifest文件
        WWW wwwManifest = WWW.LoadFromCacheOrDownload(manifestPath, 0);
        yield return wwwManifest;
        if (wwwManifest.error == null)
        {

            AssetBundle manifestBundle = wwwManifest.assetBundle;
            AssetBundleManifest manifest = (AssetBundleManifest)manifestBundle.LoadAsset("AssetBundleManifest");
            manifestBundle.Unload(false);
           
            //获取依赖文件列表
            string[] depedentAssetBundles = manifest.GetAllDependencies(assetBundleName);

            
            AssetBundle[] abs = new AssetBundle[depedentAssetBundles.Length];
            
            for (int i = 0; i < depedentAssetBundles.Length; i++)
            {
                //加载所有的依赖文件              
                WWW www = WWW.LoadFromCacheOrDownload(assetBundlePath + depedentAssetBundles[i], 0);
                yield return www;
                abs[i] = www.assetBundle;

            }
            //加载需要的文件
            WWW www2 = WWW.LoadFromCacheOrDownload(assetBundlePath + assetBundleName, 0);
            yield return www2;
            AssetBundle assetBundle = www2.assetBundle;
            //加载资源
            GameObject g = assetBundle.LoadAsset("Sphere") as GameObject;
            
            if (g != null)
            {
                //实例化
                Instantiate(g);
                assetBundle.Unload(false);
            }
           


        }
        else
        {
            Debug.Log(wwwManifest.error);
        }
       
    }

  

}
