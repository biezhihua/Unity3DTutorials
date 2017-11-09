using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ExportAssetBundles : MonoBehaviour {

   
    [MenuItem("Custom Editor/Build AssetBunldes")]
    static void CreateAssetBunldesMain()
    {

        BuildPipeline.BuildAssetBundles("Assets/AssetBundles");
        AssetBundleBuild assetBundleBuild = new AssetBundleBuild();
        assetBundleBuild.assetBundleVariant = "sd";

    }
    [MenuItem("Custom Editor/Build Player")]
    static void BuildPlayer()
    {

        string[] levels = GetLevelsFormBuildSettings();
        if (levels.Length == 0)
        {
            Debug.Log("Nothing to build.");
            return;
        }
        string targetName = GetBuildTargetName(EditorUserBuildSettings.activeBuildTarget);
        if(targetName==null)
            return;
        BuildOptions option = EditorUserBuildSettings.development ? BuildOptions.Development : BuildOptions.None;
        BuildPipeline.BuildPlayer(levels, "PlayerBuild" + targetName, EditorUserBuildSettings.activeBuildTarget,
            option);
        
    }

    private static string[] GetLevelsFormBuildSettings()
    {
        List<string> levels = new List<string>();
        for (int i = 0; i < EditorBuildSettings.scenes.Length; i++)
        {
            if (EditorBuildSettings.scenes[i].enabled)
            {
                levels.Add(EditorBuildSettings.scenes[i].path);
                Debug.Log(levels[i]);
            }
        }
        return levels.ToArray();
    }

    private static string GetBuildTargetName(BuildTarget target)
    {
        switch (target)
        {
            case BuildTarget.Android:
                return "/test.apk";
            case BuildTarget.StandaloneWindows:
            case BuildTarget.StandaloneWindows64:
                return "/test.exe";
            case BuildTarget.StandaloneOSXIntel:
            case BuildTarget.StandaloneOSXIntel64:
            case BuildTarget.StandaloneOSXUniversal:
                return "/test.app";
            case BuildTarget.WebPlayer:
            case BuildTarget.WebPlayerStreamed:
                return "";
            default:
                Debug.Log("Target not implemented.");
                return null;
        }
    }
}
