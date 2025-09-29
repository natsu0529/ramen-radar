import java.io.FileInputStream
import java.util.Properties
import java.io.File

// 1. key.properties を複数候補パスから読み込む（android 配下 or リポジトリ直下）
val properties = Properties()
val keyPropsCandidates = listOf(
    File(rootProject.rootDir, "key.properties"),                 // android/key.properties
    File(rootProject.rootDir.parentFile, "key.properties"),      // repo-root/key.properties
    File(project.rootDir, "key.properties")                      // android/app/key.properties
)
val keystoreProperties: File? = keyPropsCandidates.firstOrNull { it.exists() }
if (keystoreProperties != null) {
    properties.load(FileInputStream(keystoreProperties))
}

// 必須プロパティが揃っているかを判定し、署名設定を明確に制御する
val hasSigningProps = listOf("storeFile", "storePassword", "keyAlias", "keyPassword")
    .all { properties.getProperty(it)?.isNotBlank() == true }

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.suzukioff.ramenradar"
    compileSdk = flutter.compileSdkVersion
    
    // NDKのバージョン固定は外し、環境にあるNDKを使用

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.suzukioff.ramenradar"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ネイティブライブラリのデバッグシンボルのストリップを無効化（NDKツール未整備環境の一時回避）
    packaging {
        jniLibs {
            // ストリップ処理自体を無効化
            doNotStrip += "**/*.so"
            // 念のためデバッグシンボルも保持（上と併用でもOK）
            keepDebugSymbols += "**/*.so"
        }
    }

    // 2. リリース署名設定 (signingConfigs) の定義
    signingConfigs {
        if (hasSigningProps) {
            create("release") {
                // key.propertiesから情報を取得して設定。storeFileは必ずファイルを参照する必要があります。
                val storeFilePath = properties.getProperty("storeFile")
                val keystoreFile = file(storeFilePath)
                if (!keystoreFile.exists()) {
                    throw GradleException("Keystore file not found: ${'$'}storeFilePath")
                }
                storeFile = keystoreFile
                storePassword = properties.getProperty("storePassword")
                keyAlias = properties.getProperty("keyAlias")
                keyPassword = properties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // 3. リリースビルドに「release」署名設定を適用する（プロパティが揃っている場合のみ）
            if (hasSigningProps) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // 必須情報が無ければ未署名でビルド（後でPlay Consoleで署名する場合等）
                logger.lifecycle("[android] Release signing skipped: missing key.properties entries. Checked: ${keyPropsCandidates.joinToString()}")
            }

            // NDKが無い環境でのビルドを安定化: ネイティブのデバッグシンボル生成を無効化
            ndk {
                debugSymbolLevel = "none"
            }
        }
        
        // デバッグビルドは既存の debug config を使用
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
