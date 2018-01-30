module Fastlane
  module Actions
    module SharedValues
      REMOVE_TAG_CUSTOM_VALUE = :REMOVE_TAG_CUSTOM_VALUE
    end

    class RemoveTagAction < Action
        # action 真正的执行逻辑
      def self.run(params)
      
      # 1. action 名称
      # 2. 功能: 可以删除,本地 & 远程标签
      # 3. remove_tag(tagName:0.1.0, rL:true, rR:true)
      #    remove_tag(tagName:0.1.0) 删除本地和远程标签
      #    rL: 可选 bool default:true
      #    rR: 可选 bool default:true
      # 4. git tag -d xxx  git push origin :xxx
      
      
      # 取出, 传递过来的三个参数
      tagName = params[:tagName]
      rL = params[:rL] # 如果外界没有传递这个参数, 获取的是默认值
      rR = params[:rR] # 如果外界没有传递这个参数, 获取的是默认值
      
      # 1. 拼接需要执行的具体命令
      # 1.1 定义一个命令数组
      cmds = []
      if rL
        cmds << "git tag -d #{tagName}"
      end
      if rR
        cmds << "git push origin :#{tagName}"
      end
  
      UI.message("发现了#{tagName}标签已经存在, 此时, 即将执行删除动作 🎯.")
      # 2. 执行命令
      # 接受的是具体命令的字符串
      resultCmd = cmds.join(" & ")
      Actions.sh(resultCmd)
      
      
      end

      #####################################################
      # @!group Documentation
      #####################################################

# action 描述
      def self.description
        "可以删除,本地 & 远程标签"
      end
  # action 具体描述
      def self.details
        "remove_tag(tagName:0.1.0, rL:true, rR:true) remove_tag(tagName:0.1.0) 删除本地和远程标签"
      end
# 参数
      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :tagName,
                                       description: "需要被删除的标签名称",
                                       is_string:true,
                                       optional:false
                                       ),
            FastlaneCore::ConfigItem.new(key: :rL,
                                         description: "是否需要删除本地标签",
                                         is_string:false,
                                         optional:true,
                                         default_value:true
                                         ),
            FastlaneCore::ConfigItem.new(key: :rR,
                                         description: "是否需要删除远程标签",
                                         is_string:false,
                                         optional:true,
                                         default_value:true
                                         )

        ]
      end
# 输出
      def self.output
        ""
      end
# 返回值
      def self.return_value
        nil
      end

# 作者

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["王大顺/xxx@qq.com"]
      end
# 平台支持
      def self.is_supported?(platform)
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 

        platform == :ios
      end
    end
  end
end
